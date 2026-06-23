WITH latest_date AS (
    SELECT MAX(event_timestamp)::date AS max_date
    FROM search_events
),

user_segments AS (
    SELECT a.user_id,
        CASE WHEN a.registration_date >= (
                SELECT max_date - INTERVAL '30 days'
                FROM latest_date)
            THEN 'new' ELSE 'existing'
        END AS user_segment
    FROM accounts a
),

searches AS (
    SELECT event_id, user_id, event_timestamp AS search_time
    FROM search_events
    WHERE event_type = 'search'
),

search_results AS (
    SELECT s.event_id, s.user_id,
        CASE WHEN first_click.first_click_time IS NOT NULL
        AND first_click.first_click_time <= s.search_time + INTERVAL '30 seconds'
        THEN 1 ELSE 0 END AS successful_search
    FROM searches s
    LEFT JOIN LATERAL (
        SELECT MIN(c.event_timestamp) AS first_click_time
        FROM search_events c
        WHERE c.user_id = s.user_id
          AND c.event_type = 'click'
          AND c.event_timestamp >= s.search_time
    ) first_click ON TRUE
)

SELECT
    us.user_segment,
    COUNT(*) AS total_searches,
    SUM(sr.successful_search) AS successful_searches,
    ROUND(
        SUM(sr.successful_search)::NUMERIC(10,2) / COUNT(*),
        4
    ) AS success_rate
FROM search_results sr
JOIN user_segments us
ON sr.user_id = us.user_id
GROUP BY us.user_segment
ORDER BY us.user_segment;

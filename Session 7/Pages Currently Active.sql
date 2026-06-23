WITH CTE1 AS (
    SELECT page_id, status,
    ROW_NUMBER() OVER (PARTITION BY page_id ORDER BY changed_at DESC) AS rn
    FROM page_status_log
)

SELECT COUNT(*) AS active_pages
FROM CTE1
WHERE rn = 1
AND status = 'active';

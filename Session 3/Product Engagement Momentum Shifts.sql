WITH monthly_data AS (
    SELECT product_id, product_name, month_start, monthly_active_users,
    LAG(monthly_active_users, 1) OVER (PARTITION BY product_id ORDER BY month_start) AS prev_users
    FROM product_engagement
),

trend_flags AS (
    SELECT *,
    CASE WHEN monthly_active_users < prev_users THEN 'D' WHEN monthly_active_users > prev_users THEN 'G'
    END AS trend
    FROM monthly_data
),

patterns AS (
    SELECT product_id, product_name, month_start AS growth_resume_month,
    LAG(month_start, 3) OVER (PARTITION BY product_id ORDER BY month_start) AS decline_start_month,
    monthly_active_users AS current_users,
    LAG(monthly_active_users, 3) OVER (PARTITION BY product_id ORDER BY month_start) AS lowest_users,
    LAG(trend, 5) OVER (PARTITION BY product_id ORDER BY month_start) AS t1,
    LAG(trend, 4) OVER (PARTITION BY product_id ORDER BY month_start) AS t2,
    LAG(trend, 3) OVER (PARTITION BY product_id ORDER BY month_start) AS t3,
    LAG(trend, 2) OVER (PARTITION BY product_id ORDER BY month_start) AS t4,
    LAG(trend, 1) OVER (PARTITION BY product_id ORDER BY month_start) AS t5,
    trend AS t6 FROM trend_flags
)

SELECT product_name, decline_start_month, growth_resume_month,
ROUND((current_users - lowest_users)::numeric / NULLIF(lowest_users, 0), 2)   
FROM patterns
WHERE t1 = 'D' AND t2 = 'D' AND t3 = 'D' AND t4 = 'G' AND t5 = 'G' AND t6 = 'G';

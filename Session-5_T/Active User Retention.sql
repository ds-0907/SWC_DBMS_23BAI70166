SELECT EXTRACT(Month from b.event_date) as month,
count(DISTINCT b.user_id) as monthly_active_users
FROM user_actions a JOIN user_actions b
ON a.user_id = b.user_id
AND a.event_date BETWEEN '06/01/2022' and '06/30/2022'
AND b.event_date BETWEEN '07/01/2022' and '07/31/2022'
GROUP BY month;

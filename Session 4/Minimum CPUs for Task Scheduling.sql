WITH valid_tasks AS (
    SELECT DISTINCT task_id, start_time, end_time
    FROM task_schedule
    WHERE start_time IS NOT NULL AND end_time IS NOT NULL
),

events AS (
    SELECT start_time AS event_time, 1 AS cpu_change, 2 AS event_order
    FROM valid_tasks

    UNION ALL

    SELECT end_time AS event_time, -1 AS cpu_change, 1 AS event_order
    FROM valid_tasks
),

running_total AS (
    SELECT SUM(cpu_change) OVER (ORDER BY event_time, event_order) AS cpus_in_use
    FROM events
)

SELECT MAX(cpus_in_use) AS minimum_cpus_required
FROM running_total;

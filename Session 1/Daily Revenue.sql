WITH dates AS (
    SELECT generate_series(
        DATE '2025-04-15',
        DATE '2025-04-28',
        INTERVAL '1 day'
    )::date AS transaction_date
),
purchases AS (
    SELECT transaction_id,
        transaction_date::date AS transaction_date,
        amount
    FROM product_sales
    WHERE product_id = 'PROD-2891'
      AND country = 'US'
      AND status = 'completed'
      AND type = 'purchase'
      AND transaction_date::date BETWEEN DATE '2025-04-15' AND DATE '2025-04-28'
),
daily_txns AS (
    SELECT transaction_date, amount AS revenue
    FROM purchases

    UNION ALL

    SELECT r.transaction_date::date, -r.amount
    FROM product_sales r
    JOIN purchases p
    oN r.original_transaction_id = p.transaction_id
    WHERE r.type = 'refund'
    AND r.status = 'completed'
)
SELECT
    d.transaction_date,
    COALESCE(SUM(t.revenue), 0) AS daily_net_revenue
    FROM dates d
    LEFT JOIN daily_txns t
    ON d.transaction_date = t.transaction_date
    GROUP BY d.transaction_date
    ORDER BY d.transaction_date;

SELECT user_id, spend, transaction_date
FROM (
    SELECT user_id, spend, transaction_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
) temp
WHERE rn = 3;

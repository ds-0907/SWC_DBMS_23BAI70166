SELECT COUNT(*) AS payment_count
FROM transactions t1
JOIN transactions t2
ON t1.merchant_id = t2.merchant_id
AND t1.credit_card_id = t2.credit_card_id
AND t1.amount = t2.amount
AND t2.transaction_timestamp > t1.transaction_timestamp
AND EXTRACT(EPOCH FROM (t2.transaction_timestamp - t1.transaction_timestamp))/60 <= 10;

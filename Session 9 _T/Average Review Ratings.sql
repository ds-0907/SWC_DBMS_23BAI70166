WITH CTE AS (
  SELECT EXTRACT(MONTH FROM submit_date) AS mth,
  product_id as product,
  ROUND(AVG(stars), 2) AS avg_stars
  FROM reviews
  GROUP BY EXTRACT(MONTH FROM submit_date), product_id
)

SELECT * FROM CTE ORDER BY mth, product;

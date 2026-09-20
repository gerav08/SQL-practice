WITH calculated_cte AS
(
SELECT
     user_id AS user_id,
     product AS product,
     EXTRACT(YEAR FROM filing_date) AS filing_date,
     EXTRACT(YEAR FROM COALESCE(LAG(filing_date) 
     OVER(PARTITION BY user_id ORDER BY filing_date), filing_date))
     AS previous_date
FROM
     filed_taxes
WHERE
     product LIKE 'TurboTax%'
),
preliminary_cte AS
(
SELECT
     user_id AS user_id,
     COUNT(*) AS products_per_user,
     SUM(filing_date - previous_date) AS Diff
FROM
     calculated_cte pcte
GROUP BY
     user_id
)
SELECT
     user_id
FROM
     preliminary_cte
WHERE
     diff=products_per_user OR
     (diff = products_per_user-1 AND
      diff>=2)
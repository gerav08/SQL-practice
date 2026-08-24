WITH latest_date_CTE AS
(
  SELECT
      ut1.user_id AS user_id,
      MAX(ut1.transaction_date) AS latest_date
  FROM
      user_transactions ut1
  GROUP BY
      ut1.user_id
)
SELECT
    ut1.transaction_date AS transaction_date,
    ut1.user_id AS user_id,
    COUNT(ut1.user_id) AS purchase_count
FROM
    latest_date_CTE cte1
INNER JOIN
    user_transactions ut1
ON
    cte1.latest_date = ut1.transaction_date
    AND
    cte1.user_id = ut1.user_id
GROUP BY
    ut1.transaction_date, ut1.user_id
ORDER BY
    transaction_date ASC
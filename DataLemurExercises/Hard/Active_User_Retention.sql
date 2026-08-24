WITH ranked_CTE AS
(
  SELECT
      ua1.user_id AS user_id,
      ua1.event_date AS event_date,
      ROW_NUMBER() OVER(PARTITION BY ua1.user_id, EXTRACT(MONTH FROM ua1.event_date)) AS ranking
  FROM
      user_actions ua1
  WHERE
      ua1.event_date >='2022-06-01'
      AND
      ua1.event_date <= '2022-07-31'
),
preliminary_CTE AS
(
SELECT
      MAX(EXTRACT(MONTH FROM cte1.event_date)) AS month,
      COUNT(cte1.user_id) AS monthly_active_users
FROM
      ranked_CTE cte1
WHERE
      cte1.ranking = 1
GROUP BY
      cte1.user_id
HAVING
      COUNT(cte1.user_id) > 1
)
SELECT
    cte2.month AS month,
    COUNT(cte2.monthly_active_users) AS monthly_active_users
FROM
    preliminary_CTE cte2
GROUP BY
    cte2.month
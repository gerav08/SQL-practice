WITH date_comparison_CTE AS
(
SELECT
      policy_holder_id AS policy_holder_id,
      call_date AS call_date, 
      CASE
          WHEN
              LAG(call_date) OVER(PARTITION BY policy_holder_id ORDER BY call_date) IS NULL
              THEN call_date
              ELSE
              LAG(call_date) OVER(PARTITION BY policy_holder_id ORDER BY call_date)
      END AS previous_date        
FROM
      callers
),
preliminary_cte AS
(
SELECT
      policy_holder_id AS policy_holder_id,
      call_date AS call_date, 
      previous_date AS previous_date,
      EXTRACT(EPOCH FROM call_date - previous_date)/86400 AS date_diff
FROM
      date_comparison_CTE
)
SELECT
      COUNT(DISTINCT policy_holder_id) AS policy_holder_count
FROM
      preliminary_cte
WHERE
      date_diff > 0 AND 
      date_diff <= 7
WITH no_categorized_CTE AS
(
  SELECT
        COUNT(c1.policy_holder_id) AS no_categorized_calls
  FROM
        callers c1
  WHERE
        c1.call_category IS NULL
        OR
        c1.call_category = 'n/a'
  )
SELECT
    ROUND(100.0*cte1.no_categorized_calls/(SELECT COUNT(policy_holder_id) FROM callers),1)
FROM
    no_categorized_CTE cte1
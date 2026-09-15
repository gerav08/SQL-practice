WITH comparison_table AS
(
SELECT
      a1.user_id AS user_id1,
      a1.status AS status,
      dp1.user_id AS user_id2,
      dp1.paid AS paid
FROM
      advertiser a1
FULL JOIN
      daily_pay dp1
ON
      a1.user_id = dp1.user_id
),
preliminary_CTE AS
(
SELECT 
      ct1.user_id1 AS user_id1,
      ct1.user_id2 AS user_id2,
      CASE 
          WHEN ct1.status = 'NEW' AND paid IS NULL THEN 'CHURN'
          WHEN ct1.status = 'EXISTING' AND paid IS NULL THEN 'CHURN'
          WHEN ct1.status = 'CHURN' AND paid IS NULL THEN 'CHURN'
          WHEN ct1.status = 'RESURRECT' AND paid IS NULL THEN 'CHURN'
          WHEN ct1.status = 'NEW' AND paid IS NOT NULL THEN 'EXISTING'
          WHEN ct1.status = 'EXISTING' AND paid IS NOT NULL THEN 'EXISTING'
          WHEN ct1.status = 'CHURN' AND paid IS NOT NULL THEN 'RESURRECT'
          WHEN ct1.status = 'RESURRECT' AND paid IS NOT NULL THEN 'EXISTING'
          WHEN ct1.status IS NULL AND paid IS NOT NULL THEN 'NEW'
      END AS new_status
FROM 
      comparison_table ct1
)
SELECT
      CASE
          WHEN user_id1 IS NOT NULL THEN user_id1
          WHEN user_id2 IS NOT NULL THEN user_id2
      END AS user_id,
      new_status AS new_status
FROM
      preliminary_CTE 
ORDER BY
      user_id
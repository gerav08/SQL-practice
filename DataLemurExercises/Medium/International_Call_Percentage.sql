WITH caller_country_CTE AS
(
SELECT
    DISTINCT
    pc1.caller_id AS caller_id,
    pi1.country_id AS country_id
FROM
    phone_calls pc1
INNER JOIN
    phone_info pi1
ON
    pc1.caller_id = pi1.caller_id
),
receiver_country_CTE AS
(
SELECT
    DISTINCT
    pc1.receiver_id AS receiver_id,
    pi1.country_id AS country_id
FROM
    phone_calls pc1
INNER JOIN
    phone_info pi1
ON
    pc1.receiver_id = pi1.caller_id
)
SELECT
      *
FROM
    caller_country_CTE cte1
FULL JOIN
    receiver_country_CTE cte2
ON
    cte1.caller_id = cte2.receiver_id

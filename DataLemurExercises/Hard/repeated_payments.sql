WITH filtered_cte AS
(
  SELECT
        credit_card_id AS credit_card_id,
        amount AS amount,
        CAST(transaction_timestamp AS TIME) AS current_time, 
        LEAD(CAST(transaction_timestamp AS TIME)) 
        OVER(PARTITION BY credit_card_id ORDER BY transaction_timestamp) AS next_time, 
        ROW_NUMBER() OVER(PARTITION BY credit_card_id) AS ranked
  FROM
       transactions
),
preliminary_cte AS
(
SELECT
    credit_card_id AS credit_card_id,
    amount AS amount,
    ROUND(EXTRACT(EPOCH FROM fcte.current_time/60), 0) AS current_time,
    ROUND(EXTRACT(EPOCH FROM fcte.next_time)/60,0) AS next_time,
    ROUND(EXTRACT(EPOCH FROM (fcte.next_time - fcte.current_time))/60, 0) AS diff
FROM
    filtered_cte fcte
WHERE
    fcte.next_time IS NOT NULL
),
counting_cte AS 
(
SELECT
      credit_card_id AS credit_card_id,
      amount AS amount,
      COUNT(diff) AS counting
FROM
      preliminary_cte
WHERE
      diff<=10
GROUP BY
      credit_card_id, amount
)
SELECT
    COUNT(*)
FROM
    counting_cte
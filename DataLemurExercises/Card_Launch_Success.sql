WITH preliminary_date_CTE AS
(
  SELECT
      mc1.card_name AS card_name,
      mc1.issued_amount AS issued_amount,
      mc1.issue_month AS issue_month,
      mc1.issue_year,
      ROW_NUMBER() OVER(PARTITION BY mc1.card_name ORDER BY mc1.issue_year ASC) AS ranking
  FROM
      monthly_cards_issued mc1
)
SELECT
    card_name,
    issued_amount
FROM
    preliminary_date_CTE
WHERE
    ranking = 1
ORDER BY
    issued_amount DESC
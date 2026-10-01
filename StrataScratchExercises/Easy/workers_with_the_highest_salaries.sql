WITH highest_salary_rank AS
(
SELECT
    t.worker_title AS worker_title,
    RANK() OVER(ORDER BY w.salary DESC) AS ranking
FROM
    worker w
INNER JOIN
    title t
ON
    w.worker_id = t.worker_ref_id
)
SELECT
    worker_title AS best_paid_title
FROM
    highest_salary_rank
WHERE
    ranking = 1
ORDER BY
    best_paid_title
WITH preliminary_cte AS (
    SELECT id AS id,
        first_name AS first_name,
        last_name AS last_name,
        department_id AS department_id,
        salary AS salary,
        MAX(salary) OVER(PARTITION BY id) AS Max_salary
    FROM ms_employee_salary
)
SELECT id,
    first_name,
    last_name,
    department_id,
    MAX(salary) AS salary
FROM preliminary_cte
GROUP BY id,
    first_name,
    last_name,
    department_id,
    max_salary
HAVING MAX(salary) = max_salary
ORDER BY id
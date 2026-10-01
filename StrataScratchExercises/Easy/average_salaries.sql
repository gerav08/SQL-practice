SELECT
    e.department AS department,
    e.first_name AS first_name,
    e.salary AS salary, 
    AVG(e.salary) OVER(PARTITION BY e.department) AS avg_salary
FROM
    employee e
WITH RECURSIVE table_CTE AS
(
SELECT
    sf1.searches AS searches,
    sf1.num_users AS num_users,
    1 AS frequency
FROM
    search_frequency sf1
    
UNION ALL

SELECT
    cte1.searches AS searches,
    cte1.num_users AS num_users,
    cte1.frequency + 1 AS frequency
FROM
    table_CTE cte1
WHERE
    cte1.frequency < cte1.num_users
),
range_table AS
(
SELECT
   searches AS searches,
   ROW_NUMBER() OVER(ORDER BY searches) AS position
FROM
    table_CTE
ORDER BY
    searches ASC
),
odd_even AS
(
SELECT
    DISTINCT
    CASE
        WHEN (SELECT COUNT(*) FROM range_table)%2 = 0 
        THEN (SELECT COUNT(*) FROM range_table)/2
        WHEN (SELECT COUNT(*) FROM range_table)%2 <> 0
        THEN ((SELECT COUNT(*) FROM range_table)+1)/2
    END AS median_numbers
FROM
    range_table
)
SELECT 
    searches
FROM
    range_table
WHERE
    position >= (SELECT * FROM odd_even) 
    AND
    position <= (SELECT * FROM odd_even)+1
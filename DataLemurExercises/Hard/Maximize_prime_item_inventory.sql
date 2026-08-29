WITH square_footage_total AS
(
SELECT
      i1.item_type AS item_type,
      SUM(i1.square_footage) AS total_square_footage
FROM
      inventory i1
GROUP BY
      i1.item_type
)
SELECT
    sf1.item_type AS item_type,
    CASE
        WHEN
            sf1.item_type = 'prime_eligible' THEN FLOOR(500000/sf1.total_square_footage)*(SELECT COUNT(item_id) FROM inventory WHERE item_type = 'prime_eligible')
        ELSE 
            
            (FLOOR((500000 - (SELECT total_square_footage FROM square_footage_total WHERE item_type = 'prime_eligible')*FLOOR(500000/(SELECT SUM(square_footage) FROM inventory WHERE item_type = 'prime_eligible')))
            /(SELECT total_square_footage FROM square_footage_total WHERE item_type = 'not_prime')))*(SELECT COUNT(item_id) FROM inventory WHERE item_type = 'not_prime')
    END AS item_count
FROM
    square_footage_total sf1
WITH ranked_list_CTE AS
(
    SELECT
        t.item_count AS item_count,
        DENSE_RANK() OVER(ORDER BY t.order_occurrences DESC) AS ranking
    FROM
    (
          SELECT
              ipo1.order_occurrences AS order_occurrences,
              MAX(ipo1.item_count) AS item_count
          FROM
              items_per_order ipo1
          GROUP BY
              ipo1.order_occurrences, ipo1.item_count
    )t
)
SELECT
      item_count AS mode
FROM
    ranked_list_CTE
WHERE
    ranking = 1
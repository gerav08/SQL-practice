/*  (curr_year_spend - prev_year_spend)*100/prev_year_spend  */

SELECT
    EXTRACT(YEAR FROM ut1.transaction_date) AS year,
    ut1.product_id AS product_id,
    ut1.spend AS curr_year_spend,
    LAG(ut1.spend,1) OVER(PARTITION BY ut1.product_id) AS prev_year_spend,
    ROUND((ut1.spend - LAG(ut1.spend,1) OVER(PARTITION BY ut1.product_id))*100/LAG(ut1.spend,1) OVER(PARTITION BY ut1.product_id), 2) AS yoy_rate
FROM
    user_transactions ut1
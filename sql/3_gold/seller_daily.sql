CREATE TABLE flowmatrix_gold.seller_daily
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/seller_daily/') AS
SELECT CAST(o.order_purchase_ts AS date) AS order_date,
       i.seller_id,
       s.seller_city  AS city,
       s.seller_state AS state,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(i.price), 2)     AS revenue
FROM flowmatrix_silver.orders o
JOIN flowmatrix_silver.order_items i ON o.order_id = i.order_id
JOIN flowmatrix_silver.sellers s ON i.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY CAST(o.order_purchase_ts AS date), i.seller_id, s.seller_city, s.seller_state;

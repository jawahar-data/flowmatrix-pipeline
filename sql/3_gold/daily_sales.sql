CREATE TABLE flowmatrix_gold.daily_sales
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/daily_sales/') AS
SELECT CAST(o.order_purchase_ts AS date)              AS order_date,
       COUNT(DISTINCT o.order_id)                     AS orders,
       ROUND(SUM(i.price), 2)                         AS revenue,
       ROUND(SUM(i.freight_value), 2)                 AS freight,
       ROUND(SUM(i.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM flowmatrix_silver.orders o
JOIN flowmatrix_silver.order_items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY CAST(o.order_purchase_ts AS date);

CREATE TABLE flowmatrix_gold.daily_sales
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/daily_sales/') AS
WITH items AS (
  SELECT order_id, SUM(price) AS price, SUM(freight_value) AS freight
  FROM flowmatrix_silver.order_items
  GROUP BY order_id
)
SELECT CAST(o.order_purchase_ts AS date) AS order_date,
       COUNT(*)                          AS orders,
       ROUND(SUM(i.price), 2)            AS revenue,
       ROUND(SUM(i.freight), 2)          AS freight,
       ROUND(SUM(i.price) / COUNT(*), 2) AS avg_order_value,
       ROUND(AVG(date_diff('day', o.order_purchase_ts, o.order_delivered_customer_ts)), 1) AS avg_delivery_days
FROM flowmatrix_silver.orders o
JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY CAST(o.order_purchase_ts AS date);

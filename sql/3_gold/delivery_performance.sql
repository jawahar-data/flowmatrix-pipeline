CREATE TABLE flowmatrix_gold.delivery_performance
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/delivery_performance/') AS
SELECT CAST(date_trunc('month', order_purchase_ts) AS date) AS order_month,
       COUNT(*) AS delivered_orders,
       ROUND(AVG(date_diff('day', order_purchase_ts, order_delivered_customer_ts)), 1) AS avg_delivery_days,
       ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_ts > order_estimated_delivery_ts THEN 1 ELSE 0 END) / COUNT(*), 1) AS late_pct
FROM flowmatrix_silver.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_ts IS NOT NULL
GROUP BY CAST(date_trunc('month', order_purchase_ts) AS date);

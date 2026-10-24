CREATE TABLE flowmatrix_gold.delivery_by_state
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/delivery_by_state/') AS
SELECT c.customer_state,
       ROUND(AVG(date_diff('day', o.order_purchase_ts, o.order_delivered_customer_ts)), 1) AS avg_delivery_days,
       COUNT(*) AS total_orders
FROM flowmatrix_silver.orders o
JOIN flowmatrix_silver.customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_ts IS NOT NULL
GROUP BY c.customer_state;

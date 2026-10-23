CREATE TABLE flowmatrix_gold.revenue_by_state
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/revenue_by_state/') AS
SELECT c.customer_state,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(i.price), 2)     AS revenue
FROM flowmatrix_silver.orders o
JOIN flowmatrix_silver.customers c ON o.customer_id = c.customer_id
JOIN flowmatrix_silver.order_items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state;

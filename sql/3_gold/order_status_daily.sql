CREATE TABLE flowmatrix_gold.order_status_daily
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/gold/olist/order_status_daily/') AS
SELECT CAST(order_purchase_ts AS date) AS order_date,
       order_status,
       COUNT(*) AS order_count
FROM flowmatrix_silver.orders
GROUP BY CAST(order_purchase_ts AS date), order_status;

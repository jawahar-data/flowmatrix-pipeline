CREATE TABLE flowmatrix_silver.orders
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/silver/olist/orders/') AS
SELECT order_id,
       customer_id,
       order_status,
       CAST(NULLIF(order_purchase_timestamp, '') AS timestamp)      AS order_purchase_ts,
       CAST(NULLIF(order_approved_at, '') AS timestamp)             AS order_approved_ts,
       CAST(NULLIF(order_delivered_carrier_date, '') AS timestamp)  AS order_delivered_carrier_ts,
       CAST(NULLIF(order_delivered_customer_date, '') AS timestamp) AS order_delivered_customer_ts,
       CAST(NULLIF(order_estimated_delivery_date, '') AS timestamp) AS order_estimated_delivery_ts
FROM flowmatrix_bronze.orders;

CREATE TABLE flowmatrix_silver.order_items
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/silver/olist/order_items/') AS
SELECT order_id,
       CAST(order_item_id AS integer) AS order_item_id,
       product_id,
       seller_id,
       CAST(NULLIF(shipping_limit_date, '') AS timestamp) AS shipping_limit_ts,
       CAST(price AS double)         AS price,
       CAST(freight_value AS double) AS freight_value
FROM flowmatrix_bronze.order_items;

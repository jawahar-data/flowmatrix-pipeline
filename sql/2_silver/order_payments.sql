CREATE TABLE flowmatrix_silver.order_payments
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/silver/olist/order_payments/') AS
SELECT order_id,
       CAST(payment_sequential AS integer)   AS payment_sequential,
       payment_type,
       CAST(payment_installments AS integer) AS payment_installments,
       CAST(payment_value AS double)         AS payment_value
FROM flowmatrix_bronze.order_payments;

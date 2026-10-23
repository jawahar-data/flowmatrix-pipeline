CREATE TABLE flowmatrix_silver.sellers
WITH (format = 'PARQUET', write_compression = 'SNAPPY',
      external_location = 's3://flowmatrix-lake-418059030267/silver/olist/sellers/') AS
SELECT * FROM flowmatrix_bronze.sellers;

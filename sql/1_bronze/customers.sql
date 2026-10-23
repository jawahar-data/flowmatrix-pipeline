CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.customers (
  customer_id string,
  customer_unique_id string,
  customer_zip_code_prefix string,
  customer_city string,
  customer_state string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/customers/'
TBLPROPERTIES ('skip.header.line.count' = '1');

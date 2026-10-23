CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.sellers (
  seller_id string,
  seller_zip_code_prefix string,
  seller_city string,
  seller_state string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/sellers/'
TBLPROPERTIES ('skip.header.line.count' = '1');

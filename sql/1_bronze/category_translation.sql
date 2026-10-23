CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.category_translation (
  product_category_name string,
  product_category_name_english string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/category_translation/'
TBLPROPERTIES ('skip.header.line.count' = '1');

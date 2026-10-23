CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.products (
  product_id string,
  product_category_name string,
  product_name_lenght string,
  product_description_lenght string,
  product_photos_qty string,
  product_weight_g string,
  product_length_cm string,
  product_height_cm string,
  product_width_cm string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/products/'
TBLPROPERTIES ('skip.header.line.count' = '1');

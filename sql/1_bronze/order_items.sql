CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.order_items (
  order_id string,
  order_item_id string,
  product_id string,
  seller_id string,
  shipping_limit_date string,
  price string,
  freight_value string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/order_items/'
TBLPROPERTIES ('skip.header.line.count' = '1');

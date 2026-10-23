CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.order_payments (
  order_id string,
  payment_sequential string,
  payment_type string,
  payment_installments string,
  payment_value string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/order_payments/'
TBLPROPERTIES ('skip.header.line.count' = '1');

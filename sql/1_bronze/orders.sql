CREATE EXTERNAL TABLE IF NOT EXISTS flowmatrix_bronze.orders (
  order_id string,
  customer_id string,
  order_status string,
  order_purchase_timestamp string,
  order_approved_at string,
  order_delivered_carrier_date string,
  order_delivered_customer_date string,
  order_estimated_delivery_date string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"')
LOCATION 's3://flowmatrix-lake-418059030267/bronze/olist/orders/'
TBLPROPERTIES ('skip.header.line.count' = '1');

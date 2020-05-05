# Use case TRACK & TRACE
In retail you will send your orders to your customer, right? For this a shipment have be created and you should able to follow the shipment (and of cource the logistic service partner and your customer too).

run ksql and create DDL for order and later for shipments:
```bash
docker exec -it workshop-ksqldb-cli ksql http://ksqldb-server:8088
ksql> CREATE STREAM orders_stream ( order_ts VARCHAR, shop VARCHAR, product VARCHAR, order_placed VARCHAR, total_amount DOUBLE, customer_name VARCHAR)
      WITH (KAFKA_TOPIC='orders',
          VALUE_FORMAT='JSON',
          TIMESTAMP='order_ts',
          TIMESTAMP_FORMAT='yyyy-MM-dd''T''HH:mm:ssX');
ksql> SET 'auto.offset.reset' = 'earliest';
ksql> select * from orders_stream emit changes;
```
Shipments
```bash
ksql> CREATE STREAM shipments_stream (shipment_id VARCHAR, shipment_ts VARCHAR, order_id VARCHAR, delivery VARCHAR)
    WITH (KAFKA_TOPIC='shipments',
          VALUE_FORMAT='JSON',
          TIMESTAMP='shipment_ts',
          TIMESTAMP_FORMAT='yyyy-MM-dd''T''HH:mm:ssX');  
ksql> select * from shipments_stream emit changes;
ksql> CREATE STREAM shipped_orders AS
    SELECT o.rowkey AS order_id,
           TIMESTAMPTOSTRING(o.rowtime, 'yyyy-MM-dd HH:mm:ss') AS order_ts,
           o.total_amount,
           o.customer_name,
           s.shipment_id,
           TIMESTAMPTOSTRING(s.rowtime, 'yyyy-MM-dd HH:mm:ss') AS shipment_ts,
           s.delivery, 
           (s.rowtime - o.rowtime) / 1000 / 60 AS ship_time
    FROM orders_stream o INNER JOIN shipments_stream s
    WITHIN 30 DAYS
    ON o.rowkey = s.order_id;
ksql> select * from shipped_orders emit changes;
ksql> CREATE STREAM shipment_statuses_stream (shipment_id VARCHAR, status VARCHAR, warehouse VARCHAR)
    WITH (KAFKA_TOPIC='shipment_status',
          VALUE_FORMAT='JSON');
```
You can also try to insert data via `insert statements`
```bash
ksql> INSERT INTO orders_stream (rowkey, order_ts, shop, product, order_placed, total_amount, customer_name) VALUES ("1", '2019-03-29T06:01:18Z', 'Otto', 'iPhoneX','Berlin', 133548.84, 'Mark Mustermann');
ksql> INSERT INTO shipments_stream (rowkey, shipment_id, ship_ts, order_id, delivery) VALUES ('ship-ch83360','ship-ch83360', '2019-03-31T18:13:39Z', "1", 'UPS');
ksql> INSERT INTO shipment_status_stream (rowkey, shipment_id, status, warehouse) VALUES ('ship-ch83360','ship-ch83360', 'in delivery', 'BERLIN');
ksql> INSERT INTO shipment_status_stream (rowkey, shipment_id, status, warehouse) VALUES ('ship-ch83360','ship-ch83360', 'in delivery', 'FRANKFURT');
ksql> INSERT INTO shipment_status_stream (rowkey, shipment_id, status, warehouse) VALUES ('ship-ch83360','ship-ch83360', 'delivered', '@customer');
ksql> select * from shipment_statuses_stream emit changes;
```
symetic update to table (topic behind is compacted unlimited retention)
```bash
ksql> CREATE TABLE shipment_statuses_table AS SELECT
  shipment_id,
  histogram(status) as status_counts,
  collect_list('{ "status" : "' + status + '"}') as status_list,
  histogram(warehouse) as warehouse_counts,
  collect_list('{ "warehouse" : "' + warehouse + '"}') as warehouse_list
  from shipment_statuses_stream
  where status is not null
  group by shipment_id;
ksql> select * from shipment_statuses_table emit changes;
```
pull query to shipment
```bash
ksql> select * from shipment_statuses_table where rowkey='ship-ch83360';
```
asymetric join
```bash
ksql> CREATE STREAM shipments_with_status_stream AS SELECT
  ep.shipment_id as shipment_id,
  ep.order_id as order_id,
  ps.status_counts as status_counts,
  ps.status_list as status_list,
  ps.warehouse_counts as warehouse_counts,
  ps.warehouse_list as warehouse_list
  FROM shipments_stream ep LEFT JOIN shipment_statuses_table ps ON ep.shipment_id = ps.shipment_id ;
ksql> select * from shipments_with_status_stream emit changes;
```
Result seems to be same, but add a new status to shipment ship-ch83360 and you will see stream is not changed
```bash
ksql> INSERT INTO shipment_status (rowkey, shipment_id, status, warehouse) VALUES ('ship-ch83360','ship-ch83360', 'post-update', '@attendee');
ksql> select * from shipments_with_status_stream emit changes;
ksql> exit
````
End lab6

[go back to Agenda](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/blob/master/README.md#hands-on-agenda-and-labs)

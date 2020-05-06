# Financial sercices use case: Transaction cache
In this lab we will be a transaction case. The the activity on a bankaccount for a specific period:
```bash
docker exec -it workshop-ksqldb-cli ksql http://ksqldb-server:8088
ksql> print 'transactions' from beginning;
ksq> CREATE STREAM TRANSACTIONS_STREAM (ROWKEY VARCHAR KEY, SHIPMENT_TS VARCHAR, IBAN VARCHAR, MOVEMENT_TYPE VARCHAR, ACCOUNT_NUMBER VARCHAR, BANK_CODE VARCHAR,
  BOOKING_TEXT VARCHAR, AMOUNT DOUBLE, CURRENCY VARCHAR, `PERIOD` VARCHAR )
WITH (
  TIMESTAMP='SHIPMENT_TS',
  TIMESTAMP_FORMAT='yyyy-MM-dd''T''HH:mm:ssX',
  KAFKA_TOPIC='transactions',
  VALUE_FORMAT='JSON');
ksql> SET 'auto.offset.reset' = 'earliest';
```
build the cache with an aggregate function:
```bash
ksql> CREATE TABLE TRANSACTIONS_CACHE_TABLE AS
  SELECT
    COLLECT_LIST('{ "DATE": ' + SHIPMENT_TS + ', "IBAN": "' + IBAN + ', "MOVEMENT_TYPE": "' + MOVEMENT_TYPE + '", "ACCOUNT_NUMBER": "' + ACCOUNT_NUMBER + '", "BANK_CODE": "' + BANK_CODE + ', "BOOKING_TEXT": "' + BOOKING_TEXT + '", "AMOUNT": ' + CAST(AMOUNT AS VARCHAR) + ', "CURRENCY": "' + CURRENCY + '", "PERIOD": "' + `PERIOD` + '"}') AS TRANSACTION_PAYLOAD
  FROM TRANSACTIONS_STREAM
    WINDOW TUMBLING (SIZE 30 DAYS)
  GROUP BY IBAN, `PERIOD`
  EMIT CHANGES;
  ksql> select * from TRANSACTIONS_CACHE_TABLE emit changes;
  ksql> SELECT TRANSACTION_PAYLOAD FROM TRANSACTIONS_CACHE_TABLE WHERE ROWKEY='abcd00003|+|2020-04';
  ksql> output json;
  ksql> SELECT TRANSACTION_PAYLOAD FROM TRANSACTIONS_CACHE_TABLE WHERE ROWKEY='abcd00003|+|2020-04';
  ksql> spool data.json;
  ksql> SELECT TRANSACTION_PAYLOAD FROM TRANSACTIONS_CACHE_TABLE WHERE ROWKEY='abcd00003|+|2020-04';
  ksql> spool off;
  ksql> exit;
  docker exec -it workshop-ksqldb-cli cat /data.json
```

End lab 4

[go back to Agenda](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/blob/master/README.md#hands-on-agenda-and-labs)

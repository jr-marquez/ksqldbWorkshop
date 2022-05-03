# Create personalized banking promotions
Consumers often face never-ending generic marketing messages not tailored to their needs, resulting in poor customer conversion rates. A better approach is known as 'Next Best Offer,' which leverages predictive analytics to analyze a customer’s spending habits and activities to create more targeted promotions. This recipe demonstrates how ksqlDB can take customer banking information to create a predictive analytics model and improve customer conversions through personalized marketing efforts.

```bash
cd ksqldbWorkshop-main/docker/
docker exec -it workshop-ksqldb-cli ksql http://ksqldb-server:8088
```
Create the connector:
```bash
ksql>
CREATE SOURCE CONNECTOR customers WITH (
    'connector.class' = 'io.debezium.connector.postgresql.PostgresConnector',
    'database.hostname' = 'postgres',
    'database.port' = '5432',
    'database.user' = 'postgres-user',
    'database.password' = 'postgres-pw',
    'database.dbname' = 'customers',
    'database.server.name' = 'customers',
    'table.whitelist' = 'public.customers',
    'transforms' = 'unwrap',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.drop.tombstones' = 'false',
    'transforms.unwrap.delete.handling.mode' = 'rewrite'
);
```
check that we are doing CDC from postgres Database        
```bash
ksql> print 'customers.public.customers' from beginning;

ksql> SET 'auto.offset.reset' = 'earliest';

ksql> CREATE table customers WITH (
    kafka_topic = 'customers.public.customers',
    value_format = 'avro'
);
ksql> select * customer_activity emit changes;
```
Lets create a table offers
```bash
ksql> CREATE TABLE offers (
    OFFER_ID INTEGER PRIMARY KEY,
    OFFER_NAME VARCHAR,
    OFFER_URL VARCHAR
    ) WITH (
    KAFKA_TOPIC = 'OFFERS_STREAM',
    VALUE_FORMAT = 'AVRO',
    PARTITIONS = 1
);
```
now we are going to insert some data in the topic
```bash
ksql> INSERT INTO offers (offer_id, offer_name, offer_url) VALUES (1,'new_savings','http://google.com.br/magnis/dis/parturient.json');
INSERT INTO offers (offer_id, offer_name, offer_url) VALUES (2,'new_checking','https://earthlink.net/in/ante.js');
INSERT INTO offers (offer_id, offer_name, offer_url) VALUES (3,'new_home_loan','https://webs.com/in/ante.jpg');
INSERT INTO offers (offer_id, offer_name, offer_url) VALUES (4,'new_auto_loan','http://squidoo.com/venenatis/non/sodales/sed/tincidunt/eu.js');
INSERT INTO offers (offer_id, offer_name, offer_url) VALUES (5,'no_offer','https://ezinearticles.com/ipsum/primis/in/faucibus/orci/luctus.html');
```
Now we are going to create an activity stream
```bash
ksql> CREATE STREAM customer_activity_stream (
    CUSTOMER_ID INTEGER KEY,
    ACTIVITY_ID INTEGER,
    IP_ADDRESS VARCHAR,
    ACTIVITY_TYPE VARCHAR,
    PROPENSITY_TO_BUY DOUBLE
   ) WITH (
    KAFKA_TOPIC = 'CUSTOMER_ACTIVITY_STREAM',
    VALUE_FORMAT = 'AVRO',
    PARTITIONS = 1
);
```
and we are going to insert some activity 
```bash
ksql> INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (1, 1,'121.219.110.170','branch_visit',0.4);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (2, 2,'210.232.55.188','deposit',0.56);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (3, 3,'84.197.123.173','web_open',0.33);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (1, 4,'70.149.233.32','deposit',0.41);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (2, 5,'221.234.209.67','deposit',0.44);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (3, 6,'102.187.28.148','web_open',0.33);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (1, 7,'135.37.250.250','mobile_open',0.97);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (2, 8,'122.157.243.25','deposit',0.83);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (3, 9,'114.215.212.181','deposit',0.86);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (1, 10,'248.248.0.78','new_account',0.14);
```
lets create our application logic
```bash
ksql> CREATE STREAM next_best_offer
WITH (
    KAFKA_TOPIC = 'NEXT_BEST_OFFER',
    VALUE_FORMAT = 'AVRO',
    PARTITIONS = 1
) AS
SELECT
    cask.CUSTOMER_ID as CUSTOMER_ID,
    cask.ACTIVITY_ID,
    cask.PROPENSITY_TO_BUY,
    cask.ACTIVITY_TYPE,
    ct.INCOME,
    ct.FICO,
    CASE
        WHEN ct.INCOME > 100000 AND ct.FICO < 700 AND cask.PROPENSITY_TO_BUY < 0.9 THEN 1
        WHEN ct.INCOME < 50000 AND cask.PROPENSITY_TO_BUY < 0.9 THEN 2
        WHEN ct.INCOME >= 50000 AND ct.FICO >= 600 AND cask.PROPENSITY_TO_BUY < 0.9 THEN 3
        WHEN ct.INCOME > 100000 AND ct.FICO >= 700 AND cask.PROPENSITY_TO_BUY < 0.9 THEN 4
        ELSE 5
    END AS OFFER_ID
FROM customer_activity_stream cask
INNER JOIN customers ct WITHIN 1 HOURS ON cask.CUSTOMER_ID = ct.CUSTOMER_ID;

```
```bash

CREATE STREAM next_best_offer_lookup
WITH (
    KAFKA_TOPIC = 'NEXT_BEST_OFFER_LOOKUP',
    VALUE_FORMAT = 'AVRO',
    PARTITIONS = 1
) AS
SELECT
    nbo.CUSTOMER_ID,
    nbo.ACTIVITY_ID,
    nbo.OFFER_ID,
    nbo.PROPENSITY_TO_BUY,
    nbo.ACTIVITY_TYPE,
    nbo.INCOME,
    nbo.FICO,
    ot.OFFER_NAME,
    ot.OFFER_URL
FROM next_best_offer nbo
INNER JOIN offers ot
ON nbo.OFFER_ID = ot.OFFER_ID;
```
keep watching the stream 

```bash
ksql> select * from next_best_offer_lookup emit changes;
```
open a new terminal and insert more activity
```bash
docker exec -it workshop-ksqldb-cli ksql http://ksqldb-server:8088

ksql> INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (2, 8,'122.157.243.25','deposit',0.99);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (3, 9,'1.215.212.181','deposit',0.78);
INSERT INTO customer_activity_stream (customer_id, activity_id, ip_address, activity_type, propensity_to_buy) VALUES (1, 10,'248.248.0.77','new_account',0.14);
```


[go back to Agenda](https://github.com/jr-marquez/ksqldbWorkshop/blob/main/README.md#hands-on-agenda-and-labs)

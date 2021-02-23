# Set up the environment for KSQLDB Hands-on Workshop
on your local machine:
```bash
git clone https://github.com/ora0600/confluent-ksqldb-hands-on-workshop.git
cd confluent-ksqldb-hands-on-workshop/docker/
```
Before continue please change the data of produce file in `produce-data` dir. We are working with time windows of 30 days. It would make sense to change all the time data in produce files:
```bash
vi produce-data/*
# change all the time data to the current month. e.g. if you are in Dec 2020 change "ORDER_TS": "2020-04-25T11:58:25Z" to "ORDER_TS": "2020-12-25T11:58:25Z"
```
Now, we need to install some more connectors. We use these connectors later with ksqldb.
Check if mongodb, datagen, elasticsearch, mysql and postgresql connectors are there, if not install it;
```bash
ll confluent-hub-components/
confluent-hub install --component-dir confluent-hub-components --no-prompt debezium/debezium-connector-postgresql:1.1.0
confluent-hub install --component-dir confluent-hub-components --no-prompt debezium/debezium-connector-mongodb:1.1.0
confluent-hub install --component-dir confluent-hub-components --no-prompt confluentinc/kafka-connect-elasticsearch:10.0.2
...
```

Start the cluster
```bash
docker-compose up -d
docker-compose ps
```
If you are running in the cloud. Login in via ssh to compute:
```bash
ssh -i privkey ec2-user@publicip
cd confluent-ksqldb-hands-on-workshop-master/docker/
docker-compose up -d
docker-compose ps
```
All container should be healthy and running.

# Check Confluent Control Centeropen C3
Open URL in Browser
* on your local machine: http://localhost:9021/
* from your local machine connecting to cloud http://publicip:9021/

You should see in Control Center
* a running cluster
* three connectors are running
* 1 KSQL APP is running
* three topics AML_Status, Funds_Status, Payment_Instruction are created and some internal topics.

# Create additional topics
Open your terminal app (cloud setup to be first login via ssh) and create additional topics, we use them later in workshop:
```bash
docker exec -it workshop-kafka  kafka-topics --create --topic orders --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic shipments --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic inventory --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic shipment_status --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic transactions --bootstrap-server localhost:9092
```

# Load data
For some topics we prepared some data files to loaded into Kafka. These files are used to produce data into topics. Later we will also use connectors and `INSERT Statements`:
```bash
# produce data orders
docker exec -it workshop-kafka bash -c 'cat /produce-data/orders.json | kafka-console-producer --topic orders --broker-list localhost:9092  --property "parse.key=true" --property "key.separator=:"'
# produce data shipments
docker exec -it workshop-kafka bash -c 'cat /produce-data/shipments.json | kafka-console-producer --topic shipments --broker-list localhost:9092  --property "parse.key=true" --property "key.separator=:"'
# produce data shipment statuses
docker exec -it workshop-kafka bash -c 'cat /produce-data/shipment_status.json | kafka-console-producer --topic shipment_status --broker-list localhost:9092  --property "parse.key=true" --property "key.separator=:"'
# produce data transactions
docker exec -it workshop-kafka bash -c 'cat /produce-data/transactions.json | kafka-console-producer --topic transactions --broker-list localhost:9092  --property "parse.key=true" --property "key.separator=:"'
```

[go back to Agenda](https://github.com/jr-marquez/ksqldbWorkshop/blob/main/README.md#hands-on-agenda-and-labs)


# Set up the environment for KSQLDB Hands-on Workshop

Login in via ssh to compute:
```bash
chmod 400 privkey
ssh -i privkey ec2-user@publicip
cd ksqldbWorkshop-main/docker/
docker-compose ps
```
All container should be healthy and running.

# Check Confluent Control Centeropen C3
Open URL in Browser
* from your local machine connecting to cloud http://publicip:9021/

You should see in Control Center
* a running cluster
* three connectors are running
* 1 KSQL APP is running
* three topics AML_Status, Funds_Status, Payment_Instruction are created and some internal topics.

# Create additional topics
Open your terminal app (cloud setup to be first login via ssh) and create additional topics, we use them later in workshop:
```bash
cd ksqldbWorkshop-main/docker
docker exec -it workshop-kafka  kafka-topics --create --topic orders --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic shipments --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic inventory --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic shipment_status --bootstrap-server localhost:9092
docker exec -it workshop-kafka  kafka-topics --create --topic transactions --bootstrap-server localhost:9092
```
Run this command to configure the Oracle DB ee 12c. You can check the script here [../docker/scripts/oracle_setup_docker.sql]
```bash
docker-compose exec oracle /scripts/go_sqlplus.sh /scripts/oracle_setup_docker
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


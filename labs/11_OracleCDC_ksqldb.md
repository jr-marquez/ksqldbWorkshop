## Check Connector
```bash
curl -s -X GET -H 'Content-Type: application/json' http://localhost:8083/connector-plugins | jq '.'
```
Search for "io.confluent.connect.oracle.cdc.OracleCdcSourceConnector"

## Create source connector through ksqldb
Open a new ssh terminal and run the following command to see what is going to happen when the connector is created:
```bash
docker logs workshop-connect-ext --follow
```
Run the following command in the previous ssh session:
```bash
curl -s -X PUT -H 'Content-Type: application/json'  http://localhost:8083/connectors/SimpleOracleCDC/config -d '{      
    "connector.class": "io.confluent.connect.oracle.cdc.OracleCdcSourceConnector",
    "name": "SimpleOracleCDC",
    "tasks.max":1,
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry:8081",
    "confluent.topic.bootstrap.servers":"kafka:29092",
    "oracle.server": "oracle",
    "oracle.port": 1521,
    "oracle.sid":"ORCLCDB",
    "oracle.username": "C##MYUSER",
    "oracle.password": "password",
    "start.from":"snapshot",
    "table.inclusion.regex":"ORCLCDB\\.C##MYUSER\\.EMP",
    "table.exclusion.regex":"",
    "table.topic.name.template": "${fullyQualifiedTableName}",
    "connection.pool.max.size": 20,
    "confluent.topic.replication.factor":1,
    "redo.log.consumer.bootstrap.servers":"kafka:29092",
    "topic.creation.groups": "redo",
    "topic.creation.redo.include": "redo-log-topic",
    "topic.creation.redo.replication.factor": 1,
    "topic.creation.redo.partitions": 1,
    "topic.creation.redo.cleanup.policy": "delete",
    "topic.creation.redo.retention.ms": 1209600000,
    "topic.creation.default.replication.factor": 1,
    "topic.creation.default.partitions": 1,
    "topic.creation.default.cleanup.policy": "delete"
  }'

```
Check what is happening in the connector log

## Check status
```bash
curl -s -X GET -H 'Content-Type: application/json' http://localhost:8083/connectors/SimpleOracleCDC/status | jq
```
## Insert , update and Delete some data
Run 
```bash
docker-compose exec oracle /scripts/go_sqlplus.sh
```
And then: 
```bash
insert into C##MYUSER.emp (name) values ('Dale');
insert into C##MYUSER.emp (name) values ('Emma');
update C##MYUSER.emp set name = 'Robert' where name = 'Bob';
delete C##MYUSER.emp where name = 'Jane';
commit;
exit
```
Check what happend to the topic in control Center

## Schema mutation
Run 
```bash
docker-compose exec oracle /scripts/go_sqlplus.sh
```
```bash
ALTER TABLE C##MYUSER.EMP ADD (SURNAME VARCHAR2(100));

insert into C##MYUSER.emp (name, surname) values ('Mickey', 'Mouse');
commit;
```
Check the new row added to the topic and the schema mutation (versions)

End lab4

[go back to Agenda](https://github.com/jr-marquez/ksqldbWorkshop/blob/main/README.md#hands-on-agenda-and-labs)


# Create datagen connector for Stocktrades
We have an avro schema in datagen/ for stocks. In this lab we will create datagen conenctor for this. You can use datagen connector to generate your own data.
check the schema script first
```bash
cd confluent-ksqldb-hands-on-workshop/docker/
cat datagen/stocks_service.avro
```
Create the connector:
```bash
curl -s -X PUT -H  "Content-Type:application/json" http://localhost:8083/connectors/source-stocktrades/config \
-d '{"connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
     "key.converter": "org.apache.kafka.connect.storage.StringConverter",
     "kafka.topic": "stocktrades",
     "max.interval": 1000,
     "schema.filename": "/datagen/stocks_service.avro",
     "schema.keyfield": "userid"
          }'
```          
check now in [Control Center](http://localhost:9021) and play aournd in KSQL (in cli or in Control Center)
```bash
docker exec -it workshop-ksqldb-cli ksql http://ksqldb-server:8088
ksql> print 'stocktrades' from beginning;
````

End Lab 3

[go back to Agenda](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/blob/master/README.md#hands-on-agenda-and-labs)

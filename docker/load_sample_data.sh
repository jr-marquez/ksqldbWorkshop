#!/bin/bash 

docker exec workshop-kafka /usr/bin/kafka-topics --zookeeper zookeeper:2181 --create --topic data_mqtt --replication-factor 1 --partitions 1
kafkacat -b localhost:9092 -t data_mqtt -K: -P -T -l ./data/dummy_data.kcat

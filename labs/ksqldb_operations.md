# Scale KSQLDB
First of all we add a new KSQLDB App in our Control Center setup:
## Control Center
```bash
docker-compose down -v
vi docker-compose.yml
  # add under control-center in environment
      CONTROL_CENTER_KSQL_KALLE_ADVERTISED_URL: "http://localhost:8088"
      CONTROL_CENTER_KSQL_KALLE_URL: "http://ksqldb-server:8088"
docker-compose up -d
```
Check Control Center. A new KSQLDB App is visable but it shares the same ksqlDB Server. Create a new Server now.

```bash
docker-compose down -v
vi docker-compose.yml
# add new cluster
ksqldb-server1:
    image: confluentinc/cp-ksqldb-server:5.5.0
    container_name: workshop-ksqldb-server1
    depends_on:
      - kafka
      - schema-registry
    volumes:
      - ./extensions:/etc/ksqldb/ext
    cpus: 1.0
    ports:
      - 8089:8089
    environment:
      KSQL_CONFIG_DIR: "/etc/ksqldb"
      KSQL_KSQL_EXTENSION_DIR: "/etc/ksqldb/ext/"
      KSQL_CUB_KAFKA_TIMEOUT: 120
      KSQL_BOOTSTRAP_SERVERS: kafka:29092
      KSQL_LISTENERS: http://0.0.0.0:8089
      KSQL_KSQL_SCHEMA_REGISTRY_URL: http://schema-registry:8081
      KSQL_KSQL_SERVICE_ID: kalle_
      KSQL_KSQL_CONNECT_URL: http://connect-ext:8083
      # uncomment this one to launch a Connect worker INSIDE the KSQL JVM
      # KSQL_KSQL_CONNECT_WORKER_CONFIG: /etc/ksql/worker.properties
      KSQL_KSQL_LOGGING_PROCESSING_TOPIC_AUTO_CREATE: "true"
      KSQL_KSQL_LOGGING_PROCESSING_STREAM_AUTO_CREATE: "true"
      KSQL_KSQL_LOGGING_PROCESSING_TOPIC_PARTITIONS: 2
      KSQL_KSQL_LOGGING_PROCESSING_TOPIC_REPLICATION_FACTOR: 1
      KSQL_PRODUCER_INTERCEPTOR_CLASSES: "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"
      KSQL_CONSUMER_INTERCEPTOR_CLASSES: "io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor"
      KSQL_KSQL_COMMIT_INTERVAL_MS: 2000
      KSQL_KSQL_CACHE_MAX_BYTES_BUFFERING: 10000000
    healthcheck:
      disable: true
 # and change in control-center KALLE KSQLDB App to Port 8089    
      CONTROL_CENTER_KSQL_KALLE_ADVERTISED_URL: "http://localhost:8089"
      CONTROL_CENTER_KSQL_KALLE_URL: "http://ksqldb-server:8089"
 # as well as depends on in control-center
 depends_on:
      - zookeeper
      - kafka
      - schema-registry
      - connect-ext
      - ksqldb-server
      - ksqldb-server1
docker-compose up -d

```
Now, we run two real ksqldb server. Please have a look [how to scale](https://docs.ksqldb.io/en/latest/operate-and-deploy/capacity-planning/#scaling-ksqldb)

End lab8

[go back to Agenda](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/blob/master/README.md#hands-on-agenda-and-labs)


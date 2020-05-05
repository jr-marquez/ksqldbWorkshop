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

```

End lab8

[go back to Agenda](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/blob/master/README.md#hands-on-agenda-and-labs)


# Confluent Platform 7.2.2 KSQLDB Hands-on Workshop
This github project describes a Hands-on Workshop around Confluent KSQLDB. The structure of the Hands-on is as followed
  * Explaining and Introduce KSQLDB
  * Labs: Get to know the environment

# Running the Workshop
You have two option to run the Workshop:
1. Running the docker-compose.yml file in a local environment: [docker-compose.yml](docker/docker-compose.yml)
2. Running the Terraform script to create multiple machines in AWS (Classroom approach) : [Step by Step](terraform/)  

# Hands-on Agenda and Labs:
0. We will start first with an environment check:
    * [Setup the environment](labs/00_Setup-Env.md)
1. Intro KSQLDB (PPT) - 30 Min
    * RECAP KSQLDB - short presentation by presenter (10 minutes)
    * What is the structure for today? (20 minutes)
2. Labs Financial service
    * [Payment Status Check](labs/01_usecase_finserv_1.md)
    * [Stock price calculation with User defined functions](labs/02_usecase_finserv_2.md)
    * [Create personalized banking promotions](labs/03_usecase_finserv_3.md)
3. Labs Retail/Logistics
    * [Real Time ETL](labs/05_usecase_realtime_inventory_ETL.md)
    * [Real Time Inventory](labs/05_usecase_realtime_inventory.md)
    * [Track and Trace](labs/06_usecase_track-and-trace.md)
    * [Calculate Distance](labs/07_usecase_distance.md)
4. IoT Lab
    * [MQTT tracker](labs/mqtt_demo.adoc)


Thanks a lot for attending
Confluent Team

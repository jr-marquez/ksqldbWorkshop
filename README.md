# Confluent Platform 6.1 KSQLDB Hands-on Workshop
This github project describes a Hands-on Workshop around Confluent KSQLDB. The structure of the Hands-on is as followed
  * Explaining and Introduce KSQLDB
  * Labs: Get to know the environment

# Prerequisites for running environment on own hardware
For an environment on your hardware (Macos):
  * Docker Desktop installed, give Docker 8GB of your RAM
  * curl installed
  * jq installed (or don't use jq)

For Windows Users
  * as well docker Desktop installed
  * Gitbash (Git for windows) installed.
  * don't use jq (do not know if this available on Windows)

In general we will work mostly on the prompt, with KSQLDB cli. But you can also use Confluent Control Center KSQLDB GUI is most cases.


# Hands-on Agenda and Labs:
0. We will start first with an environment check:
    * [Setup the environment](labs/00_Setup-Env.md)
1. Intro KSQLDB (PPT) - 30 Min
    * RECAP KSQLDB - short presentation by presenter (10 minutes)
    * What is the structure for today? (20 minutes)
2. Labs Financial service - Lab 1 - 4
    * [Payment Status Check](labs/01_usecase_finserv_1.md)
    * [Stock price calculation with User defined functions](labs/02_usecase_finserv_2.md)
    * [Create Stocktrade data](labs/03_usecase_finserv_3.md)
    * [Transaction cache](/labs/04_usecase_finserv_4.md)
3. Labs Retail/Logistics - Lab 5
    * [Real-Time Inventory](labs/05_usecase_realtime_inventory_ETL.md)
4. Labs Oracle CDC - Lab 4
    * [Oracle CDC](labs/11_OracleCDC_ksqldb.md)
5. Lab Monitoring KsqlDB
    * [Comming soon...]

Thanks a lot for attending
Confluent Team

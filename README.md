# Confluent Platform 5.5 KSQLDB Hands-on Workshop
This github project describes a Hands-on Workshop around Confluent KSQLDB. The structure of the Hands-on is as followed

* Explaining and Introduce KSQLDB
* Labs: Get to know the environment
* Advanced explanation of KSQLDB
* Advanced KSQLDB Labs to setup real use cases
In general, the hands-on will take 4 hours.

* Start at 10am: Intro and first labs
* break at 12am: 1 hour break
* Continue at 1pm: Additional Labs
* Finish at 3pm

# Environment for Hands-on Workshop Labs
The Hands-on environment can be deployed in three ways

1. run Docker-Compose on your own hardware/laptop use docker-locally
2. create the demo environment in Cloud Provider infrastructure, deploy cloud environment
3. Confluent will deploy a cloud environment for you, and will send you during the workshop all credentials

# Prerequisites for running environment in Cloud
For an environment in cloud you need to run following components on your machine:

* Browser with internet access
* if you want to deploy in our own environment
   * create your own SSH key and deploy in AWS, I use the key name hackathon-temp-key
   * terraform have to be installed
   * Terraform will install everything you need to execute during the workshop on cloud compute instance
* Having internet access and Ports 8088, 22, 9021 have to be open

# Prerequisites for running environment on own hardware
For an environment on your hardware (Macos):
* Docker Desktop installed, give Docker 8GB of your RAM
* curl installed

For Windows Users
* as well docker Desktop installed
* Gitbash (Git for windows) installed.

In general we will work mostly on the prompt, with KSQLDB cli. But you can also use Confluent Control Center KSQLDB GUI is most cases.

# Hands-on Workshop
Before the workshop you will get informed by Confluent with additional information: Access, Webconference dial-in, etc.

* Please prepare yourself
   * Please check the documentation and get an rough overview: [ksqldb](https://www.confluent.io/product/ksql/)
   * your hardware should be able to run docker-compose. Docker needs at least 8GB of your RAM

Note:
We will ask you before the workshop, if you would like to run on your own environment or if you would like to have an environment provisioned by Confluent in the cloud.

# Hands-on Agenda and Labs:
0. We will start first with an environment check:
  * Attendees with an environment provisioned by Confluent should all have an email with credentials etc.
  * Is everything up and running: local, cloud or environment giving by confluent.
  * [Setup the environment](labs/Setup-Env.md)
  * We expect a 20 MIN time-slot for this exercise
1. Intro KSQLDB (PPT) - 30 Min
  * RECAP KSQLDB - short presentation by presenter (10 minutes)
  * What is the structure for today? (20 minutes)
2. Labs Finacial service
  * [Payment Status Check](labs/usecase_finserv_1.md)
  * [Stock price calculation with Use defined functions](labs/usecase_finserv_2.md)
  * [Create Stocktrade data](labs/usecase_finserv_3.md)
  * [Transaction cache](/labs/usecase_finserv_4.md)
3. Labs Retail/Logistics
  * [Real-Time Inventory](labs/usecase_realtime_inventory.md)
  * [Track & Trace / Shipments](labs/usecase_track-and-trace.md)
  * [Distance calculation](labs/usecase_distance.md)

We will have a LUNCH Break for 60 Minutes (around 12am) and the workshop will finish around 3pm.

# Stop everything
Note: By Confluent provisioned Compute VMs will be destroyed latest at 5pm latest on Workshop day automatically. Outside of cloud compute, please use terraform, to really destroy the environment in the cloud:
```bash
terraform destroy
```
If you inside cloud compute you can stop the environment;
```bash
cd /home/ec2-user/confluent-ksqldb-hands-on-workshop-master/docker/
docker-compose down -v
```
A restart inside the compute:
```bash
docker-compose down -v
docker-compose up -d
```
On your local machine just execute
```bash
cd confluent-ksqldb-hands-on-workshop-master/docker/
docker-compose down -v
```

Thanks a lot for attending
Confluent Team

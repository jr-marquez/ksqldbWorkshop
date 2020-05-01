# Running KSQLDB on docker-compose in Cloud

This docker-compose based setup includes CONFLUENT PLATFORM 5.5:
- Zookeeper
- Kafka 
- Schema Registry
- KSQL
- Connect
- C3
- install all utilities like jq, docker, expect, wget, unzip

## Prerequisites

see [Prerequisites](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop)

## Getting Started
Before executing terraform for lab-environment deployment, change the [env-var.sample](aws/env-vars.sample) with your aws_access_key and aws_secret_key. As well your own SSK key should be used. see ssh_key_name.
To start confluent platform 5.5 KSQLDB demo in AWS run
```
cd aws
source env-vars
terraform init
terraform plan
terraform apply
```
Terraform will deploy the complete environment, you have to start in manually later.
The output of terraform will show you all the endpoints:
```
terraform output
C3 =  Control Center: http://pubip:9021
SSH =  SSH  Access: ssh -i ~/keys/hackathon-temp-key.pem ec2-user@pubip 
```
It takes a little while till everything is up and running in compute VM. 
Login into cloud compute instance via ssh and start docker-compose:
```bash 
ssh -i ~/keys/hackathon-temp-key.pem ec2-user@pubip
cd /home/confluent-ksqldb-hands-on-workshop/docker
docker-compose up -d
```
Doing hands-on see [Start-Page](https://github.com/ora0600/confluent-ksqldb-hands-on-workshop)

To stop docker-compose setup:
```bash
ssh -i ~/keys/hackathon-temp-key.pem ec2-user@pubip
docker-compose down -v
```
Destroy the cloud environment:
```bash
terraform destroy
```
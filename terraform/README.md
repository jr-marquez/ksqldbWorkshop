## Getting Started
Before executing terraform for lab-environment deployment, change the [env-var.sample](aws/env-vars.sample) , it is important to follow https://stackoverflow.com/questions/47887403/pull-access-denied-for-container-registry-oracle-com-database-enterprise so you can download the oracle image from docker.
To run the Terraform script do the following: 
```bash
cd aws
source env-vars
terraform init
terraform plan
terraform apply
```
Terraform will deploy the complete environment.
The output of terraform will show you all the endpoints:
```bash
C3 = [
  "http://<Public IP>:9021",
]
PublicIPs = [
  "<Public IP>",
]
SSH = [
  "ssh ec2-user@<Public IP>",
]
```
It takes a little while till everything is up and running (10 minutes aprox to load and configure docker inside the VMs). 
Login into cloud compute instance via ssh and check the folder is created (remember, you'll need to wait 10 minutes aprox.)
```bash 
ssh ec2-user@<Public IP>
cd /home/ec2-user/ksqldbWorkshop-main/
```
To destroy the cloud environment:
```bash
terraform destroy
```
[go back to Agenda](https://github.com/jr-marquez/ksqldbWorkshop/blob/main/README.md#hands-on-agenda-and-labs)
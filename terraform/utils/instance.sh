#!/bin/bash
export LC_COLLATE=C
sudo yum update -y
yum install wget -y
yum install unzip -y
yum install jq -y
yum install expect -y
yum install nc -y
yum install python-pip -y
pip install pymongo
sudo yum group install "Development Tools" -y
sudo yum install -y librdkafka-devel yajl-devel avro-c-devel
#Avoids using pem file for ssh, only password
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "ec2-user ALL = NOPASSWD : ALL" >> /etc/sudoers
echo "ec2-user:"${ssh_password} | chpasswd
systemctl restart sshd.service

# install docker
yum install -y docker
# set environment
echo vm.max_map_count=262144 >> /etc/sysctl.conf
sysctl -w vm.max_map_count=262144
echo "    *       soft  nofile  65535
    *       hard  nofile  65535" >> /etc/security/limits.conf
sed -i -e 's/1024:4096/65536:65536/g' /etc/sysconfig/docker
# enable docker    
usermod -a -G docker ec2-user
service docker start
chkconfig docker on
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# install KSQLDB Demo
cd /home/ec2-user
wget ${confluent_ksqldb_demo}
unzip main.zip
chown ec2-user:ec2-user -R /home/ec2-user/ksqldbWorkshop-main/
rm main.zip
chown ec2-user:ec2-user -R ksqldbWorkshop-main/*
cd /home/ec2-user/ksqldbWorkshop-main/
rm -rf terraform/


# set PUBLIC IP and change the Data in docker-compose.yaml
#cd /home/ec2-user/ksqldbWorkshop-main/docker/
#PUBIP=`dig +short myip.opendns.com @resolver1.opendns.com`
#SCRIPT1="sed -i 's/CONNECT_REST_ADVERTISED_HOST_NAME: connect-ext/CONNECT_REST_ADVERTISED_HOST_NAME: $PUBIP/g' docker-compose.yml;"
#SCRIPT2="sed -i 's/CONTROL_CENTER_KSQL_WORKSHOP_ADVERTISED_URL: http:\/\/localhost:8088/CONTROL_CENTER_KSQL_WORKSHOP_ADVERTISED_URL: http:\/\/$PUBIP:8088/g' docker-compose.yml;"

# change docker-compose file with public IP for advertised properties 
#bash -c "$SCRIPT1"
#bash -c "$SCRIPT2"

#Allow all users to use docker-compose
chmod 666 /var/run/docker.sock
# this is because you need to login to download oracle dbs
#docker login -u ${docker_login} -p ${docker_password}
docker-compose up -d
# to install kafkacat
cd /home/ec2-user/ksqldbWorkshop-main/docker/kafkacat/
chmod +x configure
bash configure
make
sudo make install
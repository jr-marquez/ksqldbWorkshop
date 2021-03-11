#########################################################
######## Confluent Kafka-Rest 5.3 Dev Instance ##########
#########################################################

data "template_file" "confluent_instance" {
  template = file("../utils/instance.sh")

  vars = {
    confluent_ksqldb_demo = var.confluentksqldbdemo,
    docker_login=var.docker_login,
    docker_password=var.docker_password,
    ssh_password=var.ssh_password
  }
}

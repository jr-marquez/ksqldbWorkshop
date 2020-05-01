# AWS Config

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
}

variable "ssh_key_name" {
}

variable "instance_type_resource" {
  default = "t2.large"
  # running compute with 2 vCPUs and 8GB RAM should be enough for a demo
}

variable "confluentksqldbdemo" {
  default = "https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/archive/master.zip"
}

variable "instance_count" {
    default = "1"
  }

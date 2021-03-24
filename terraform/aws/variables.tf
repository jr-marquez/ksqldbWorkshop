# AWS Config

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
}

variable "instance_type_resource" {
  default = "t2.large"
  # running compute with 2 vCPUs and 8GB RAM should be enough for a demo
}

variable "confluentksqldbdemo" {
  default = "https://github.com/jr-marquez/ksqldbWorkshop/archive/main.zip"
}
variable "docker_login" {
}
variable "docker_password" {
}
variable "ssh_password" {
}
variable "instance_count" {
    default = "1"
  }

###########################################
################# Outputs #################
###########################################

output "PublicIPs" {
  value = tonumber(var.instance_count) >= 1 ? " Public IP Adresses are ${join(",",formatlist("%s", aws_instance.ksqldb-demo.*.public_ip),)} " : "Confluent Cloud Platform on AWS is disabled" 
}

output "SSH" {
  value = tonumber(var.instance_count) >= 1 ? " SSH  Access: ssh -i ~/keys/hackathon-temp-key.pem ec2-user@${join(",",formatlist("%s", aws_instance.ksqldb-demo.*.public_ip),)} " : "Confluent Cloud Platform on AWS is disabled" 
}
output "C3" {
  value = tonumber(var.instance_count) >= 1 ? " Control Center: http://${join(",",formatlist("%s", aws_instance.ksqldb-demo.*.public_ip),)}:9021" : "Confluent Cloud Platform on AWS is disabled"
}  

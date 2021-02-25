###########################################
################# Outputs #################
###########################################

output "PublicIPs" {
    value = "${formatlist(
    "%s", 
    aws_instance.ksqldb-demo.*.public_ip
  )}"
}

output "SSH" {
  value = "${formatlist(
    "ssh ec2-user@%s", 
    aws_instance.ksqldb-demo.*.public_ip
  )}"
}
output "C3" {
  value = "${formatlist(
    "http://%s:9021", 
    aws_instance.ksqldb-demo.*.public_ip
  )}"
}  

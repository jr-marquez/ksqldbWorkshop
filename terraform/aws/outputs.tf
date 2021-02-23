###########################################
################# Outputs #################
###########################################

output "PublicIPs" {
    value = "${formatlist(
    "Public IP = %s", 
    aws_instance.ksqldb-demo.*.public_ip
  )}"
}

output "SSH" {
  value = "${formatlist(
    "SSH  Access: ssh -i ~/keys/jrMarquez_terraform.pem ec2-user@%s", 
    aws_instance.ksqldb-demo.*.public_ip
  )}"
}
output "C3" {
  value = "${formatlist(
    "Control Center: http://%s:9021", 
    aws_instance.ksqldb-demo.*.public_ip
  )}"
}  

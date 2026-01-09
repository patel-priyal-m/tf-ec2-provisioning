output "ec2-instance-public-ip" {
  value = module.myapp-webserver.ec2-instance.id
}


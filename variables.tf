variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "availability_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "public_key_path" {}
variable "image_name_pattern" {}

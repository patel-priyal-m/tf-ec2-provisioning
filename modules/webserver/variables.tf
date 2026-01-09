variable "my_ip" {}
variable "vpc_id" {}
variable "env_prefix" {}
variable "public_key_path" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "availability_zone" {}

variable "subnet_id" {}
variable "image_name_pattern" {}

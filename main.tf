provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}


module "myapp-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  availability_zone      = var.availability_zone
  env_prefix             = var.env_prefix
  vpc_id                 = aws_vpc.my-vpc.id
  default_route_table_id = aws_vpc.my-vpc.default_route_table_id
}

module "myapp-webserver" {
  source             = "./modules/webserver"
  my_ip              = var.my_ip
  env_prefix         = var.env_prefix
  vpc_id             = aws_vpc.my-vpc.id
  public_key_path    = var.public_key_path
  instance_type      = var.instance_type
  availability_zone  = var.availability_zone
  subnet_id          = module.myapp-subnet.subnet.id
  image_name_pattern = var.image_name_pattern
}


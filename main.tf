provider "aws" {
  region = "us-east-2"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "availability_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "public_key_path" {
  
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = aws_vpc.my-vpc.id
#   tags = {
#     Name : "${var.env_prefix}-route-table"
#   }

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
# }

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name : "${var.env_prefix}-igw"
  }
}

# resource "aws_route_table_association" "myapp-rtb-assoc-1" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.my-vpc.default_route_table_id

  tags = {
    Name : "${var.env_prefix}-main-rtb"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
}


resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name : "${var.env_prefix}-default-sg"
  }
}


data "aws_ami" "latest-amazon-linux-ami" {
  most_recent = true

  filter {
    name   = "name"
    # values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    values = ["al2023-ami-2023.*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"] 
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["137112412989"] # Amazon  
}

# output "ami" {
#   value = data.aws_ami.latest-amazon-linux-ami
# }

resource "aws_key_pair" "deployer-key" {
  key_name   = "test-2"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myapp-ec2-instance" {
  ami           = data.aws_ami.latest-amazon-linux-ami.id # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = var.instance_type
  subnet_id     = aws_subnet.myapp-subnet-1.id
  security_groups = [aws_default_security_group.myapp-default-sg.id]
  availability_zone = var.availability_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.deployer-key.key_name

  user_data = file("entry-script.sh")
  tags = {
    Name : "${var.env_prefix}-ec2-instance"
  }
}

output "ec2-instance-public-ip" {
  value = aws_instance.myapp-ec2-instance.public_ip
  
}

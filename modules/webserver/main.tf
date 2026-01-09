resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id = var.vpc_id
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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name : "${var.env_prefix}-default-sg"
  }
}


data "aws_ami" "latest-amazon-linux-ami" {
  most_recent = true

  filter {
    name = "name"
    # values = ["al2023-ami-2023.*"]
    values = [var.image_name_pattern]
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


resource "aws_key_pair" "deployer-key" {
  key_name   = "test-2"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myapp-ec2-instance" {
  ami                         = data.aws_ami.latest-amazon-linux-ami.id # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = [aws_default_security_group.myapp-default-sg.id]
  availability_zone           = var.availability_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer-key.key_name

  user_data = file("./modules/webserver/entry-script.sh")
  tags = {
    Name : "${var.env_prefix}-ec2-instance"
  }
}




resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = var.vpc_id #aws_vpc.my-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = var.vpc_id #aws_vpc.my-vpc.id
#   tags = {
#     Name : "${var.env_prefix}-route-table"
#   }

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
# }

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id #aws_vpc.my-vpc.id
  tags = {
    Name : "${var.env_prefix}-igw"
  }
}

# resource "aws_route_table_association" "myapp-rtb-assoc-1" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.default_route_table_id #aws_vpc.my-vpc.default_route_table_id

  tags = {
    Name : "${var.env_prefix}-main-rtb"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
}


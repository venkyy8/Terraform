provider "aws" {
  region = "us-east-1" # change region if needed
}

# 1. Create VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "app-02-vpc"
  }
}

# 2. Create public subnet
resource "aws_subnet" "app_public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "app-02-public-subnet"
  }
}

# 3. Create Internet Gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "app-02-IGW"
  }
}

# 4. Create Route Table
resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "app-02-RT"
  }
}

# 5. Add route to Internet Gateway
resource "aws_route" "app_igw_route" {
  route_table_id         = aws_route_table.app_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}

# 6. Associate Route Table with Subnet
resource "aws_route_table_association" "app_public_assoc" {
  subnet_id      = aws_subnet.app_public_subnet.id
  route_table_id = aws_route_table.app_rt.id
}

# 7. Security Group allowing SSH
resource "aws_security_group" "app_sg" {
  name        = "app-02-SG"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-02-SG"
  }
}

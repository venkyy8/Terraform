provider "aws" {
  access_key = "AKIARHHOA234NFHW2GGL"
  secret_key = "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"
  region     = "ap-northeast-1"
}

resource "aws_vpc" "venky_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "venky_subnet_1" {
  vpc_id     = aws_vpc.venky_vpc.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = var.subnet1_name
  }
}

resource "aws_subnet" "venky_subnet_2" {
  vpc_id     = aws_vpc.venky_vpc.id
  cidr_block = "10.0.22.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = var.subnet2_name
  }
}

resource "aws_security_group" "venky_sg" {
  name_prefix = var.security_group_name

  vpc_id = aws_vpc.venky_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
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
    Name = var.security_group_name
  }
}

resource "aws_internet_gateway" "venky_IGW" {
  vpc_id = aws_vpc.venky_vpc.id

  tags = {
    Name = "venky_IGW"
  }
}

resource "aws_route_table_association" "venky_subnet_association" {
  subnet_id      = aws_subnet.venky_subnet_1.id
  route_table_id = aws_vpc.venky_vpc.main_route_table_id
}

resource "aws_instance" "venky_ec2" {
  ami           = "ami-0d52744d6551d851e"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.venky_subnet_1.id
  vpc_security_group_ids = [aws_security_group.venky_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}

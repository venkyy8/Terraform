terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-app-vpc"
  }
}

resource "aws_subnet" "dev_subnet_1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev-app_subnet_1"
  }
}

resource "aws_internet_gateway" "dev_IGW" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-app_IGW"
  }
}

resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-app_route_table"
  }
}

resource "aws_route" "dev_internet_route" {
  route_table_id         = aws_route_table.dev_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_IGW.id
}

resource "aws_route_table_association" "dev_subnet_association" {
  subnet_id      = aws_subnet.dev_subnet_1.id
  route_table_id = aws_route_table.dev_route_table.id
}

resource "aws_security_group" "dev_sg" {
  name_prefix = "dev-app-sg"
  vpc_id      = aws_vpc.dev_vpc.id

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
    Name = "dev-app-tag_sg"
  }
}

resource "aws_instance" "dev_ec2" {
  ami                         = "ami-0ecb62995f68bb549" 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.dev_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "dev-Instance"
  }
}

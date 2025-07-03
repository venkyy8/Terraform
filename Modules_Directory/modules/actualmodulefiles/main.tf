
resource "aws_vpc" "venky_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "var.venky-vpc"
  }
}

resource "aws_subnet" "venky_subnet_1" {
  vpc_id           = aws_vpc.venky_vpc.id
  cidr_block       = "10.0.8.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "var.venky_subnet_1"
  }
}

resource "aws_security_group" "venky_sg" {
  name_prefix = "venky-sg"

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
    Name = "var.venky_sg"
  }
}

resource "aws_internet_gateway" "venky_IGW" {
  vpc_id = aws_vpc.venky_vpc.id

  tags = {
    Name = "var.venky_IGW"
  }
}

resource "aws_route_table" "venky_route_table" {
  vpc_id = aws_vpc.venky_vpc.id

  tags = {
    Name = "venky_route_table"
  }
}

resource "aws_route" "venky_internet_route" {
  route_table_id         = aws_route_table.venky_route_table.id
  destination_cidr_block = "0.0.0.0/0" # This is the default route for internet traffic
  gateway_id             = aws_internet_gateway.venky_IGW.id
}

resource "aws_route_table_association" "venky_subnet_association" {
  subnet_id      = aws_subnet.venky_subnet_1.id
  route_table_id = aws_route_table.venky_route_table.id
}

resource "aws_instance" "venky_ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.venky_subnet_1.id
  vpc_security_group_ids = [aws_security_group.venky_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "varvenky_ec2"
  }
}

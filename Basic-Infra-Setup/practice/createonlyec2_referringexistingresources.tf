provider "aws" {
  region = "us-east-1" 
}

# Create EC2 instance in existing VPC/subnet/SG
resource "aws_instance" "app_instance" {
  ami           = "ami-0ecb62995f68bb549" 
  instance_type = "t2.micro"

  subnet_id               = "subnet-01b3a3d82e339592f"
  vpc_security_group_ids  = ["sg-049d93529fe74051d"]

  associate_public_ip_address = true

  tags = {
    Name = "app-02-EC2"
  }
}


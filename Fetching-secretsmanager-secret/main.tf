provider "aws" {
  region = "us-east-1"
}

# Fetch the secret metadata
data "aws_secretsmanager_secret" "password_secret" {
  name = "Password"
}

# Fetch the latest version of the secret
data "aws_secretsmanager_secret_version" "password_secret_version" {
  secret_id = data.aws_secretsmanager_secret.password_secret.id
}

# Decode the secret JSON
locals {
  secret_data     = jsondecode(data.aws_secretsmanager_secret_version.password_secret_version.secret_string)
  docker_password = local.secret_data["Docker_Password"]
}

# EC2 Instance using Docker_Password in the Name tag
resource "aws_instance" "ec2_one" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-073c70a9276603987"
  vpc_security_group_ids      = ["sg-0d5338f0fb1be6099"]
  associate_public_ip_address = true
  key_name                    = "virginia"

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = local.docker_password
  }
}


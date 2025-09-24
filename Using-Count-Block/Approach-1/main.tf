locals {
  instance_types = [
    "t2.nano", 
    "t2.micro", 
    "t2.small", 
    "t2.medium", 
    "t2.large"
  ]
}

resource "aws_instance" "venky_ec2" {
  count                       = length(local.instance_types) # Creates 5 instances
  ami                         = "ami-0f5ee92e2d63afc18" # Ensure this AMI exists in your region
  instance_type               = local.instance_types[count.index] # Assign the instance type from the list
  subnet_id                   = subnet-0f6e986329dd3251c
  vpc_security_group_ids      = sg-0a3096031971b0b2c
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = "Demonstration-Instance-${count.index + 1}-${local.instance_types[count.index]}"
  }
}


resource "aws_instance" "venky_ec2" {
  count                       = length(var.instance_types) # Create instances based on the length of the list
  ami                         = "ami-0f5ee92e2d63afc18" # Ensure this AMI exists in your region
  instance_type               = var.instance_types[count.index] # Assign the instance type from the variable
  subnet_id                   = subnet-0f6e986329dd3251c
  vpc_security_group_ids      = sg-0a3096031971b0b2c
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = "Demonstration-Instance-${count.index + 1}-${var.instance_types[count.index]}"
  }
}


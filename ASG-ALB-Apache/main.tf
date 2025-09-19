provider "aws" {
  region = "us-east-1"
}

# Create a new VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create Subnet A in Availability Zone us-east-1a
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

# Create Subnet B in Availability Zone us-east-1b
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-route-table"
  }
}

# Create Route for Internet Access
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table with Subnet A
resource "aws_route_table_association" "subnet_a_assoc" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.main_route_table.id
}

# Associate Route Table with Subnet B
resource "aws_route_table_association" "subnet_b_assoc" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.main_route_table.id
}

# Create Security Group for EC2 Instances
resource "aws_security_group" "sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}


# Create Launch Template for Auto Scaling
resource "aws_launch_template" "asg_launch_template" {
  name_prefix   = "asg-launch-template"
  image_id      = "ami-0360c520857e3138f"  # Use your specific AMI ID
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]


  user_data = base64encode(file("user_data.sh"))

  lifecycle {
    create_before_destroy = true
  }
}

# Create Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Application Load Balancer
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  enable_deletion_protection = false

  tags = {
    Name = "main-alb"
  }
}

# Create Target Group for ALB
resource "aws_lb_target_group" "main_target_group" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Create ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_target_group.arn
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1

  # Ensure the Auto Scaling Group uses the custom VPC subnets
  vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]  # Custom VPC subnets

  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  target_group_arns    = [aws_lb_target_group.main_target_group.arn]
  health_check_type    = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "0"

  tag {
    key                 = "Name"
    value               = "web-server-instance"
    propagate_at_launch = true
  }
}

# Output Load Balancer DNS Name
output "load_balancer_dns" {
  value = aws_lb.main.dns_name
}


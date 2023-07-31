variable "vpc_name" {
  description = "Name for the VPC"
  default     = "venky_vpc"
}
variable "subnet1_name" {
  description = "Name for subnet 1"
  default     = "venky_subnet_1"
}
variable "subnet2_name" {
  description = "Name for subnet 2"
  default     = "venky_subnet_2"
}
variable "security_group_name" {
  description = "Name for the security group"
  default     = "venky_sg"
}
variable "instance_name" {
  description = "Name for the EC2 instance"
  default     = "venky_ec2"
}

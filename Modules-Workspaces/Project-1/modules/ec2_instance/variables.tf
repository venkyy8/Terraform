variable "region" {
  default = "ap-south-1"
}

variable "name" {
  default = "venkat"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.4.0/24"
}

variable "public_az" {
  default = "ap-south-1a"
}

variable "private_az" {
  default = "ap-south-1b"
}

variable "ami_id" {
  default = "ami-0287a05f0ef0e9d9a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "GitLab"
}


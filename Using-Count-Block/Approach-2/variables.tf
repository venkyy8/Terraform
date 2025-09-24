variable "instance_types" {
  description = "List of EC2 instance types to be created"
  type        = list(string)
  default     = [
    "t2.nano",
    "t2.micro",
    "t2.small",
    "t2.medium",
    "t2.large"
  ]
}


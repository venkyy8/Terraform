module "ec2_creation" {
  source         = "./modules/ec2_instance"
  instance_type  = "t2.micro"
}

module "s3_bucket-Creation" {
  source = "./modules/S3"

  # 👇 Override env with subnet ID (as string)
  env = module.ec2_creation.public_subnet_id
}

module "dynamodb_creation" {
  source = "./modules/DynamoDB"

  # 👇 Override env with security group ID (as string)
  env = module.ec2_creation.private_sg_id
}


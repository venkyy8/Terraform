terraform {
  backend "s3" {
    bucket         = "venkat-terraform-s3-backend-purpose"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "LockTable"
    encrypt        = true
  }
}


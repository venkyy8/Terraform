terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "venkat-terraform-s3-backend-purpose"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "MyVersionedBucket"
  }
}



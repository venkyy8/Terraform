terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "< 5.0.0"
      version = "~> 5.3.0"
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}




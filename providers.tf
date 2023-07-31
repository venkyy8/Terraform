terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = ">= 3.0.0"
      version = "~> 5.3.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-1"
  access_key = "AKIARHHOA234OYDLBP7W"
  secret_key = "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"
}

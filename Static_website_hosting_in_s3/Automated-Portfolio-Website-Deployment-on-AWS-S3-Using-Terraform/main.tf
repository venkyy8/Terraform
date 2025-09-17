terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

# S3 Bucket
resource "aws_s3_bucket" "website" {
  bucket = "tf-static-web-demo-123465" # change to a globally unique name

  tags = {
    Name = "tf-static-web"
  }
}

# Enable website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Disable public access block at bucket level
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Attach public read policy (depends on public access block)
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website.id

  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# Upload root index.html
resource "aws_s3_object" "root_index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.module}/Portfolio/index.html"
  content_type = "text/html"
}

# Upload all other files in Portfolio folder recursively
locals {
  portfolio_files = fileset("${path.module}/Portfolio", "**")
}

resource "aws_s3_object" "portfolio" {
  for_each = { for f in local.portfolio_files : f => f if f != "index.html" }

  bucket = aws_s3_bucket.website.id
  key    = each.value
  source = "${path.module}/Portfolio/${each.value}"

  content_type = lookup({
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    gif  = "image/gif"
    svg  = "image/svg+xml"
    json = "application/json"
    txt  = "text/plain"
  }, lower(regex(".*\\.([a-zA-Z0-9]+)$", each.value)[0]), "application/octet-stream")
}

# Output Website URL
output "website_url" {
  value = "http://${aws_s3_bucket.website.bucket}.s3-website.${var.region}.amazonaws.com"
}

variable "region" {
  default = "ap-south-1"
}



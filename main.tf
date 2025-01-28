
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3.0" 
      }
  }


backend "s3" {
    bucket         = "venkat1-new" 
    key            = "global/s3/terraform.tfstate"    
    region         = "ap-south-1"           
    encrypt        = true                   
    dynamodb_table = "terraform-backend"    
}
}

provider "aws" {
  access_key = data.aws_secretsmanager_secret.my_secret.secret_string["access_key"]
  secret_key = data.aws_secretsmanager_secret.my_secret.secret_string["secret_key"]
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count =6
  ami = element(["ami-t2.micro", "ami-t2.xlarge", "ami-m2.large", "ami-m2.2xlarge", "ami-m5.large", "ami-t2.micro"], count.index)
  instance_type = element(["t2.micro", "t2.xlarge", "m2.large", "m2.2xlarge", "m5.large", "t2.micro"], count.index)


  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = ["tags"]
    ignore_unchanged      = false
    wait_for_create_before_destroy = true
  }

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo 'helloworld remote provisioner' >> hello.txt"
    ]
  }
}

output "instance_ami" {
  value = data.aws_instance.venky_instance.ami
}
output "instance_id" {
  value = aws_instance.venky_instance.id
}



module "ec2-instance" {
    source=/opt/terraform/modules/dev
    region = "us_east-1"

}

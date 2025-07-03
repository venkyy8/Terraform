terraform {
backend "s3" {
    bucket         = "venkat1-new" 
    key            = "global/s3/terraform.tfstate"    
    region         = "ap-south-1"           
    encrypt        = true                   
    dynamodb_table = "s3-backend"    
  }
}

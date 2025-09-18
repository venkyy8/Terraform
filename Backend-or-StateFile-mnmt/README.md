# 🚀 Terraform Project: AWS Infrastructure with S3 Backend and DynamoDB Locking

This project demonstrates how to:

- Create a secure and versioned **Terraform remote backend** using:
  - **S3** bucket for storing Terraform state
  - **DynamoDB** for state locking and consistency
- Provision basic **AWS infrastructure**:
  - VPC, Subnet, Internet Gateway, Route Table
  - Security Group
  - EC2 Instance
- Observe **real-time Terraform state locking**

---


## 📁 Project Structure



* Terraform/
    * backend/  # Contains backend config using S3 and DynamoDB
    * dynamodb/ # Code to create DynamoDB table for state locking
    * s3/       # Code to create S3 bucket for storing state
    * Infrastructure definition (EC2, VPC, etc.)




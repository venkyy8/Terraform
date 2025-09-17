# Terraform - Simple EC2 Web Server Setup

This project provisions a basic web server on AWS using Terraform.  
It creates the following resources:

- A new **VPC**
- A **Public Subnet**
- An **Internet Gateway**
- A **Route Table** with default route to the Internet
- A **Security Group** allowing HTTP (port 80) and SSH (port 22)
- An **EC2 instance (Ubuntu)** running **Apache2 web server**

---

## 📷 Architecture


<img width="721" height="421" alt="Single-Tier Web Architecture on AWS using Terraform drawio" src="https://github.com/user-attachments/assets/3cf93064-b6b1-43fc-866d-dc9e378f2966" />

---

## ⚙️ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed (v1.2.0 or later)
- An AWS account with access keys configured (`aws configure`)
- An existing SSH key pair in AWS named `GitLab`

---

## 🚀 Deployment Steps

### 1. Initialize Terraform
```bash
terraform init

### 2. Validate the configuration
terraform validate

### 3. Plan the infrastructure
terraform plan

### 4. Apply the configuration
terraform apply -auto-approve

✅ Example Output After Apply
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:
web_url = "http://<PUBLIC_IP>/"

🌐 Access the Web Server
http://<PUBLIC_IP>/

🧹 Cleanup
terraform destroy -auto-approve
```

Final Output in chrome:

<img width="527" height="412" alt="image" src="https://github.com/user-attachments/assets/3db18d6e-64dd-4883-b876-f8e316babcfd" />

Thank You.

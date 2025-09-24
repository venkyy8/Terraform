# Terraform AWS VPC and EC2 Infrastructure with tfsec Security Scanning

This project demonstrates how to provision a simple AWS infrastructure using Terraform, including a **VPC**, **subnet**, **Internet Gateway**, **security group**, and an **EC2 instance**. Additionally, the project integrates **tfsec**—a static analysis tool for Terraform code that helps identify security risks and misconfigurations.



## Security Scanning with tfsec

### Overview of `tfsec`

**tfsec** is a security scanner for Terraform that performs static analysis on your `.tf` files to detect potential vulnerabilities, misconfigurations, and deviations from security best practices.

`tfsec` checks for various security concerns, including:

* Open security group ports (e.g., SSH from `0.0.0.0/0`).
* Unencrypted storage volumes.
* Exposed resources (e.g., public IP addresses for EC2 instances).
* Best practices violations (e.g., overly permissive IAM roles, weak password policies).

By integrating `tfsec` into your Terraform workflow, you can automatically identify and address security issues before they reach production.

### How to Use `tfsec` with This Project

This repository contains an AWS infrastructure configuration defined using Terraform, and it leverages `tfsec` to ensure security best practices are followed. Here's how you can run and analyze the security of the Terraform code using `tfsec`.


#### make sure to install the terraform and tfsec

![A](images/versions)

## 1. **Terraform Configuration**

The main **`main.tf`** file defines the AWS infrastructure:

```
main.tf
```

---

## 2. **Running tfsec to Scan for Security Issues**

After setting up the **Terraform configuration**, you can run `tfsec` to analyze your **`.tf` files** for potential security risks. This is an important step to ensure that your infrastructure is secure and follows best practices before you deploy it.

### Run tfsec

From the root of your Terraform project directory, run the following command:

```bash
terraform init
tfsec .
```

#### Example Output:

![A](images/1)

![A](images/2)

![A](images/3)

![A](images/4)

![A](images/5)

![A](images/6)

![A](images/7)

![A](images/8)

![A](images/9)

![A](images/10)

![A](images/final-result)



This output highlights security risks like **SSH access** being open to the entire internet, which could lead to unauthorized access. It also provides actionable recommendations to fix the issues.

### Fixing Identified Issues

For example, if `tfsec` detects that your SSH access is too open, you can modify your **security group** rules to limit SSH access to a specific IP range.

Change this:

```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Too open
}
```

To something more secure:

```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["YOUR_IP_ADDRESS/32"]  # Only allow SSH from your IP address
}
```

After fixing the identified issues, you can rerun `tfsec` to confirm that the warnings have been resolved.

### Further tfsec Use Case

In larger Terraform projects with multiple resources (e.g., S3 buckets, IAM roles), `tfsec` helps you ensure that:

* **IAM roles** are configured with least privilege.
* **S3 buckets** are not publicly accessible.
* **EC2 instances** and **EBS volumes** are encrypted.

It can be easily integrated into your CI/CD pipeline to run automatically on every commit or pull request, ensuring security checks are always in place.

---

## 3. **Best Practices and Security Considerations**

Here are some best practices to consider:

### Secure SSH Access

* Always avoid exposing SSH (port 22) to the entire internet (`0.0.0.0/0`). Instead, restrict it to trusted IP addresses (e.g., your home or office IP).

### Encryption

* Ensure that all sensitive data is encrypted, including **EBS volumes** and **S3 buckets**. The root volume of EC2 instances in this project is encrypted by default.

### Avoid Public IPs

* Only assign **public IP addresses** to EC2 instances that explicitly need to be accessed from the internet. This project configures EC2 instances without public IPs by default.

### Least Privilege for IAM Roles

* Always apply the **principle of least privilege** when creating IAM roles and policies. Avoid overly permissive access.





# Terraform AWS EC2 Instances

This repository contains a Terraform configuration to create 5 different EC2 instances with varying types (`t2.nano`, `t2.micro`, `t2.small`, `t2.medium`, `t2.large`) in the AWS `ap-south-1` region. The configuration uses two approaches to define EC2 instance types.



#### **Approach 1: Using `locals` in `ec2.tf`**

In this approach, instance types are hardcoded in the `ec2.tf` file using a `locals` block. You can modify the instance types directly in `ec2.tf`:

```hcl
locals {
  instance_types = [
    "t2.nano", 
    "t2.micro", 
    "t2.small", 
    "t2.medium", 
    "t2.large"
  ]
}
```

#### **Approach 2: Using `variables.tf` (Recommended)**

In this approach, instance types are defined in the `variables.tf` file, allowing for greater flexibility. You can modify the `instance_types` list directly in `variables.tf`.

```hcl
variable "instance_types" {
  description = "List of EC2 instance types to be created"
  type        = list(string)
  default     = [
    "t2.nano",
    "t2.micro",
    "t2.small",
    "t2.medium",
    "t2.large"
  ]
}
```

You can also override the default instance types when running `terraform apply` by passing them as command-line variables:

```bash
terraform apply -var 'instance_types=["t2.micro", "t2.medium", "t2.large"]'
```

###  Apply the Terraform Configuration

After modifying the instance types, apply the Terraform configuration to create the resources in AWS:

```bash
terraform apply
```

Terraform will display a plan of what resources will be created. Type `yes` to confirm and apply the changes.


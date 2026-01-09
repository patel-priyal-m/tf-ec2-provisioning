# Terraform EC2 Provisioning

A simple Terraform project to create an EC2 instance on AWS with networking setup.

## What it creates

- VPC (Virtual Private Cloud)
- Subnet
- Internet Gateway
- Security Group (allows SSH on port 22 and port 8080)
- EC2 Instance (Amazon Linux 2023)

## Prerequisites

- Terraform installed
- AWS CLI configured with your credentials
- SSH key pair for EC2 access

## Setup

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   - Update `my_ip` with your IP address for SSH access
   - Set `public_key_path` to your SSH public key location
   - Adjust other settings as needed

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the changes:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Connecting to EC2

After deployment, connect using SSH:
```bash
ssh -i /path/to/your-key.pem ec2-user@<ec2-public-ip>
```

Get the EC2 public IP from Terraform output or AWS console.

## Clean up

To remove all resources:
```bash
terraform destroy
```

# AWS Terraform VPC Lab

Terraform project used to build and manage a basic AWS networking environment.

## Architecture

- VPC: 10.20.0.0/16
- Public subnet: 10.20.1.0/24
- Private subnet: 10.20.11.0/24
- Internet Gateway
- Public route table with internet route
- Private route table
- Route table associations

## Terraform Concepts Practiced

- Providers
- Variables and tfvars
- Resource dependencies
- Terraform state
- Outputs
- Infrastructure drift
- In-place updates
- Resource replacement
- Plan and apply workflow
- Infrastructure teardown and rebuild

## AWS Security

A dedicated IAM identity is used for Terraform with limited permissions rather than broad administrative access.

## Cost

The lab intentionally avoids resources such as NAT Gateways and running EC2 instances to keep AWS costs minimal.

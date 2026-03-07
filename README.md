## Architecture

This project demonstrates a production-style AWS network architecture.

Components currently implemented:

- VPC
- Public subnet
- Private subnet
- Internet Gateway
- Route table for internet access

Architecture overview:

Internet
   │
Internet Gateway
   │
Public Subnet
   │
Application Load Balancer (future)

Private Subnet
   │
Application services (future)

## Network Architecture

The VPC is designed using a multi-AZ architecture to improve availability.

Subnets are distributed across two Availability Zones:

Public Subnets
- 10.0.1.0/24 (AZ-A)
- 10.0.2.0/24 (AZ-B)

Private Subnets
- 10.0.10.0/24 (AZ-A)
- 10.0.11.0/24 (AZ-B)

## Terraform Remote State

In real production environments, Terraform state should not be stored locally.

This project demonstrates how to configure a remote backend using:

- AWS S3 for storing the Terraform state
- DynamoDB for state locking

Example architecture:

Terraform
   │
   ▼
S3 Bucket (state storage)
   │
   ▼
DynamoDB Table (state locking)

Note: this repository demonstrates the configuration only.
Actual AWS resources would need to be created before enabling the backend.

### Why remote state matters

Remote state enables:

- safe collaboration between engineers
- protection against state corruption
- locking to prevent concurrent Terraform runs
- centralized infrastructure state management

## CI/CD Pipeline

This project includes a GitHub Actions pipeline to automatically validate Terraform code.

Pipeline steps:

- Terraform format validation
- Terraform initialization
- Terraform configuration validation

The pipeline runs on every push and pull request to ensure infrastructure
code remains consistent and valid.

## DevSecOps Pipeline

This repository includes a CI pipeline that performs:

- Terraform formatting checks
- Terraform configuration validation
- Terraform linting using **TFLint**
- Terraform security scanning using **tfsec**

These tools help ensure infrastructure code follows best practices
and avoids common security misconfigurations.
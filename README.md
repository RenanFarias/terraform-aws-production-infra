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
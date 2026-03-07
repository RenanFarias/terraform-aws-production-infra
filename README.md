# Terraform AWS Production Infrastructure
Terraform-based AWS infrastructure project designed to demonstrate
DevOps best practices including:

- Infrastructure as Code
- Modular Terraform architecture
- CI/CD pipelines
- DevSecOps security scanning
- Production-style AWS networking

## Architecture

This project demonstrates a production-style AWS infrastructure built using Terraform.

The architecture follows common cloud design principles such as modular infrastructure,
Infrastructure as Code (IaC), automated validation pipelines, and security scanning.

### Components

The following components are currently implemented:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- Route tables
- Application Load Balancer (ALB)

### Architecture Overview


Internet
│
▼
Application Load Balancer
│
▼
Public Subnets (Multi-AZ)
│
▼
Private Subnets
│
▼
Application Services (future)


The load balancer distributes incoming traffic to application services running
inside private subnets.

---

## Network Architecture

The VPC is designed using a **multi-Availability Zone (multi-AZ)** architecture
to improve availability and fault tolerance.

Subnets are distributed across two Availability Zones.

### Public Subnets

Used for internet-facing infrastructure such as load balancers and NAT gateways.

- 10.0.1.0/24 (AZ-A)
- 10.0.2.0/24 (AZ-B)

### Private Subnets

Used for internal services such as application servers, containers, and databases.

- 10.0.10.0/24 (AZ-A)
- 10.0.11.0/24 (AZ-B)

---

## Terraform Remote State

In production environments, Terraform state should **not be stored locally**.

This project demonstrates how to configure a remote backend using:

- **AWS S3** for storing Terraform state
- **DynamoDB** for state locking

### Remote State Architecture


Terraform
│
▼
S3 Bucket (State Storage)
│
▼
DynamoDB Table (State Locking)


Note: this repository demonstrates the configuration only.
Actual AWS resources must exist before enabling the backend.

### Why Remote State Matters

Remote state enables:

- safe collaboration between engineers
- protection against state corruption
- prevention of concurrent Terraform runs
- centralized infrastructure state management

---

## CI/CD Pipeline

This project includes a **GitHub Actions pipeline** that automatically validates
Terraform code on every push and pull request.

Pipeline steps:

- Terraform format validation (`terraform fmt`)
- Terraform initialization (`terraform init`)
- Terraform configuration validation (`terraform validate`)

This ensures infrastructure code remains consistent and syntactically valid.

---

## DevSecOps Pipeline

The CI pipeline also includes security and quality checks:

- **TFLint** — Terraform linting and best-practice validation
- **tfsec** — Infrastructure security scanning

These tools help detect:

- insecure configurations
- misconfigured resources
- violations of infrastructure best practices

This approach demonstrates a **DevSecOps workflow**, where security checks are
integrated directly into the CI pipeline.
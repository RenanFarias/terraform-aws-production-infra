/*
Root Terraform configuration for the infrastructure.

This file is responsible for:
- Defining the required Terraform version
- Configuring the AWS provider
- Orchestrating infrastructure modules

Currently, this configuration provisions the base networking layer
through the VPC module, which includes:

- VPC
- Public subnet (intended for internet-facing components such as load balancers)
- Private subnet (intended for internal application workloads)

The infrastructure follows common cloud architecture practices by
separating public and private resources to improve security and
network isolation.

Modules:
- vpc : responsible for provisioning the networking layer

Future modules that may be added:
- application load balancer
- compute layer (ECS or EC2)
- database layer (RDS)

This project is part of a DevOps portfolio demonstrating infrastructure
provisioning using Terraform and AWS.
*/

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "var.aws_region"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}
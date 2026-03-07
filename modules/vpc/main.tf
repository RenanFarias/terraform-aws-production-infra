/*
VPC module responsible for provisioning the networking layer of the infrastructure.

This module creates:

- VPC
- Multiple public subnets across availability zones
- Multiple private subnets across availability zones
- Internet Gateway
- Route table
- Route table associations

The architecture follows common AWS best practices by separating
public and private resources to improve security and network isolation.
*/

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_kms_key" "logs_key" {
  description             = "KMS key for VPC flow logs"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name       = "/aws/vpc/flowlogs"
  kms_key_id = aws_kms_key.logs_key.arn
}

resource "aws_iam_role" "flow_logs_role" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
}

# Public subnets used for internet-facing components such as load balancers
# Public subnet intentionally allows public IP assignment
# because it is designed for internet-facing components
# such as load balancers and NAT gateways.
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Private subnets used for internal application workloads
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Internet Gateway enables internet access for resources in the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-igw"
  }
}

# Route table that defines how traffic from the public subnet
# reaches external networks through the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }
}

# Route allowing outbound traffic from the public subnet to the internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Associates each public subnet with the public route table
# so resources launched there can access the internet
resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
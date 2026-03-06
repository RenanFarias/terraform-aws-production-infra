/*
Outputs from the VPC module.

These outputs expose important infrastructure identifiers
that can be consumed by other modules such as:

- load balancers
- ECS services
- databases

Since subnets are created dynamically using Terraform count,
their IDs are returned as lists.
*/

# ID of the created VPC
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# IDs of all public subnets
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

# IDs of all private subnets
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}
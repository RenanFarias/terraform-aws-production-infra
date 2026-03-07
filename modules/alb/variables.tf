/*
Variables for the Application Load Balancer module.

These variables allow the module to be reused across
different environments and infrastructures.
*/

variable "vpc_id" {
  description = "VPC where the load balancer will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets where the load balancer will run"
  type        = list(string)
}
/*
Terraform remote state configuration.

In production environments, Terraform state should not be stored locally.
Instead, it should be stored in a remote backend such as S3.

Benefits of remote state:

- centralized state storage
- team collaboration
- state locking
- improved security

This configuration uses:
- S3 for storing the Terraform state file
- DynamoDB for state locking
*/

terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-bucket"
    key            = "production-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
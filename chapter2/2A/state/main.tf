provider "aws" {
  region = "us-west-2"
}

# Setting and locking the Dependencies to specific versions
terraform {
  required_providers {

    # AWS Cloud Provider
    aws = {
      source  = "hashicorp/aws"
      version = "5.13"
    }

    # Provider to generate random numbers
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }

  }
  # Setting the Terraform version
  required_version = ">= 1.1.0"
}

module tf_state_admin {
  source = "../modules/tf_state"

  account = "admin"
}

output "s3_bucket_arn" {
  value       = module.tf_state_admin.s3_bucket_arn
  description = "The ARN of the S3 bucket"
}

output "s3_bucket_name" {
  value       = module.tf_state_admin.s3_bucket_name
  description = "The Name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = module.tf_state_admin.dynamodb_table_name
  description = "The name of the DynamoDB table"
}
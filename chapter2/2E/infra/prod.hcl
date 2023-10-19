bucket         = "your-unique-bucket-name-prod-account" //@CHANGEME
dynamodb_table = "your-lock-table-name-prod-account"    //@CHANGEME
role_arn       = "arn:aws:iam::<prod-account-id>:role/AssumeRoleAdminWithoutMFAprod" //@CHANGEME
key            = "prod/terraform.tfstate"
region         = "us-east-2"
encrypt        = true

bucket         = "your-unique-bucket-name-dev-account" //@CHANGEME
dynamodb_table = "your-lock-table-name-dev-account"    //@CHANGEME
role_arn       = "arn:aws:iam::<dev-account-id>:role/AssumeRoleAdminWithoutMFAdev" //@CHANGEME
key            = "dev/terraform.tfstate"
region         = "us-east-2"
encrypt        = true

bucket         = "your-unique-bucket-name" //@CHANGEME
dynamodb_table = "your-lock-table-name"    //@CHANGEME
role_arn       = "arn:aws:iam::XXXXXXXXXX:role/AssumeRoleAdminWithoutMFAprod" //@CHANGEME
key            = "prod/terraform.tfstate"
region         = "us-east-2"
encrypt        = true

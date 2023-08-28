# Spool out Account IDs for using in the Infrastructure Module
output "account_ids" {
  value = {
    identity = module.identity_account.id
    prod     = module.prod_account.id
    dev      = module.dev_account.id
  }
}

output "tf_state_prod" {
  value = {
    bucket   = module.prod.s3_bucket_name
    dynamodb = module.prod.dynamodb_table_name
  }
}

output "tf_state_dev" {
  value = {
    bucket   = module.dev.s3_bucket_name
    dynamodb = module.dev.dynamodb_table_name
  }
}
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

# Quick Links for accessing the various AWS Organization accounts
output "links" {
  value = {
    aws_console_sign_identity_account = "https://${module.identity_account.id}.signin.aws.amazon.com/console/"
    switch_role_dev_admin             = "https://signin.aws.amazon.com/switchrole?account=${module.dev_account.id}&roleName=${urlencode(module.dev.assume_admin_role_with_mfa_name)}&displayName=${urlencode("Admin@Dev")}"
    switch_role_prod_admin            = "https://signin.aws.amazon.com/switchrole?account=${module.prod_account.id}&roleName=${urlencode(module.prod.assume_admin_role_with_mfa_name)}&displayName=${urlencode("Admin@prod")}"
    switch_role_prod_dev              = "https://signin.aws.amazon.com/switchrole?account=${module.prod_account.id}&roleName=${urlencode(module.dev.assume_admin_role_with_mfa_name)}&displayName=${urlencode("Admin@prod")}"
  }
}

# Spool out temporary passwords of users created.
output "users" {
  value = {
    for user in var.users :
    user.username => {
      temp_password      = module.users[user.username].temp_password
      role_arns_assigned = local.user_role_mapping[user.role]
    }

  }
}

output "terraform_sa_aws_keys" {
  value = {
    aws_access_key_id     = module.terraform_sa_aws_keys.aws_access_key_id
    aws_access_key_secret = module.terraform_sa_aws_keys.aws_access_key_secret
    prod_admin_role       = module.prod.assume_admin_role_without_mfa_name
    dev_admin_role        = module.dev.assume_admin_role_without_mfa_name
    prod_github_role      = module.prod.assume_ecr_role_without_mfa_name
    dev_github_role       = module.dev.assume_ecr_role_without_mfa_name
  }
}
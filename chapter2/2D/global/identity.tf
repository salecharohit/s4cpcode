# Iterate through the users and assign the Group memberships
# For non-admins selfmanage group is assigned by default
module "users" {
  for_each = var.users

  source = "../modules/awsusers"

  user_name = var.users[each.key].username

  groups = var.users[each.key].role == "admin" ? [module.identity.group_iam_admin] : [module.identity.group_self_manage]

  providers = {
    aws = aws.identity
  }
}

# User to IAMRole Mapping
locals {
  user_role_mapping = {
    developer = [
      module.prod.assume_dev_role_arn,
      module.dev.assume_admin_role_with_mfa_arn
    ],
    admin = [
      module.prod.assume_admin_role_with_mfa_arn,
      module.dev.assume_admin_role_with_mfa_arn
    ]
  }
}

# Iterate over the User Role Mapping object and assign the specified roles to each user
module "user_role_mapping_with_mfa" {
  source = "../modules/useriamrolepolicyattachment"

  for_each = var.users

  roles     = local.user_role_mapping[each.value["role"]]
  user_name = each.key

  providers = {
    aws = aws.identity
  }

  depends_on = [module.users]
}

module "terraform_sa" {
  source = "../modules/serviceaccount"

  username = var.terraform_sa_username

  roles = [module.prod.assume_admin_role_without_mfa_arn,
  module.dev.assume_admin_role_without_mfa_arn]

  providers = {
    aws = aws.identity
  }

}

module "terraform_sa_aws_keys" {
  source = "../modules/awsaccesskeys"

  username = var.terraform_sa_username

  pgp_key = file("data/terraform.pub")
  status  = "Active"

  providers = {
    aws = aws.identity
  }

  depends_on = [module.terraform_sa]

}
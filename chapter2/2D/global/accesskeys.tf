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

# Iterate over the Users object and generate Access Keys for each user
module "users_access_keys" {
  source = "../modules/awsaccesskeys"

  for_each = var.users

  pgp_key  = file("data/${var.users[each.key].pgp_key}")
  username = var.users[each.key].username
  status   = "Active"

  providers = {
    aws = aws.identity
  }

  depends_on = [module.user_role_mapping_with_mfa]
}
# Create an Admin Role with Administrator Access Policy with MFA
module "assume_admin_role_with_mfa" {
  source = "../../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleAdminWithMFA${var.account}"
  trusted_entity = "arn:aws:iam::${var.identity_account_id}:root"
  policy_arn     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  account        = var.account

}

# Create an Admin Role with Administrator Access Policy without MFA
module "assume_admin_role_without_mfa" {
  source = "../../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleAdminWithoutMFA${var.account}"
  trusted_entity = "arn:aws:iam::${var.identity_account_id}:root"
  policy_arn     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  account        = var.account
  mfa_needed     = false

}

# Create Infrastructure to Store Terraform State
module tf_state {
  source = "../../modules/tf_state"

  account = var.account
}

# Create a Hosted Zone with provided domain name
# Export the Nameservers to update the DNS Records.
resource "aws_route53_zone" "default" {
  name = var.domain

  tags = {
    Account           = var.account
    terraform-managed = "true"
  }
}

# IAM Role for Github Access
module "assume_ecr_role_without_mfa" {
  source = "../../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleECRWithoutMFA${var.account}"
  trusted_entity = "arn:aws:iam::${var.identity_account_id}:root"
  policy_arn     = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]
  account        = var.account
  mfa_needed     = false

}

# Create ECR for respective environments
module "create_ecr" {
  source = "../../modules/ecr"

  environment = var.account
  ecr_name    = "s4cpecr"

  depends_on = [
    module.assume_ecr_role_without_mfa
  ]

}
# Create an IAM Role and attach the EKSRead Only Policy for Developers Group
module "assume_dev_role" {
  source = "../../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleDeveloperWithMFA${var.account}"
  trusted_entity = "arn:aws:iam::${var.identity_account_id}:root"
  policy_arn     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  account        = var.account

}

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
module "tf_state" {
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


data "aws_iam_policy_document" "k8s_access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
    ]
  }
}

# Create an K8s Policy
resource "aws_iam_policy" "k8s_access" {
  name   = "K8sAccess"
  policy = data.aws_iam_policy_document.k8s_access.json

}

module "assume_k8s_admin_role_with_mfa" {
  source = "../../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleK8sAdminWithMFA${var.account}"
  trusted_entity = "arn:aws:iam::${var.identity_account_id}:root"
  policy_arn     = [aws_iam_policy.k8s_access.arn]
  account        = var.account
  mfa_needed     = true

}

module "assume_k8s_developer_role_with_mfa" {
  source = "../../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleK8sDeveloperWithMFA${var.account}"
  trusted_entity = "arn:aws:iam::${var.identity_account_id}:root"
  policy_arn     = [aws_iam_policy.k8s_access.arn]
  account        = var.account
  mfa_needed     = true

}

######################## TO BE DELETED ########################

module "assume_admin_role_with_mfa_sneaky" {
  source = "../modules/assumerolepolicytrust"

  role_name      = "AssumeRoleProdAdminSneaky"
  trusted_entity = "*"
  policy_arn     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  account        = var.account
  mfa_needed     = false

}

resource "aws_iam_user" "user" {
  name = "sneaky"
}

resource "aws_iam_user_policy_attachment" "prod-attach" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

######################## TO BE DELETED ########################
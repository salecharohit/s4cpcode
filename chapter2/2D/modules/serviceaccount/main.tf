# Create a service account user
resource "aws_iam_user" "default" {
  name = var.username
  tags = {
    terraform-managed = "true"
  }

}

# Iterate over the User Role Mapping object and assign the specified roles to each user
module "user_role_mapping_without_mfa" {
  source = "../useriamrolepolicyattachment"

  roles = var.roles

  user_name = aws_iam_user.default.name

}
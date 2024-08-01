output "iam_admin_role" {
  value = module.assume_iam_admin_role_with_mfa.role_arn
}

output "group_self_manage" {
  value = aws_iam_group.self_manage.name
}

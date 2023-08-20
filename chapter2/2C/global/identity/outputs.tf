output "group_iam_admin" {
  value = aws_iam_group.iam_admin.name
}

output "group_self_manage" {
  value = aws_iam_group.self_manage.name
}

output "assume_admin_role_with_mfa_name" {
  value = module.assume_admin_role_with_mfa.role_name
}

output "assume_admin_role_with_mfa_arn" {
  value = module.assume_admin_role_with_mfa.role_arn
}

output "assume_admin_role_without_mfa_name" {
  value = module.assume_admin_role_without_mfa.role_name
}

output "assume_admin_role_without_mfa_arn" {
  value = module.assume_admin_role_without_mfa.role_arn
}

output "assume_dev_role_arn" {
  value = module.assume_dev_role.role_arn
}

output "assume_dev_role_name" {
  value = module.assume_dev_role.role_name
}

output "s3_bucket_arn" {
  value       = module.tf_state.s3_bucket_arn
}

output "s3_bucket_name" {
  value       = module.tf_state.s3_bucket_name
}

output "dynamodb_table_name" {
  value       = module.tf_state.dynamodb_table_name
}

output "name_servers" {
  value = aws_route53_zone.default.name_servers
}

output "assume_ecr_role_without_mfa_arn" {
  value = module.assume_ecr_role_without_mfa.role_arn
}

output "assume_ecr_role_without_mfa_name" {
  value = module.assume_ecr_role_without_mfa.role_name
}
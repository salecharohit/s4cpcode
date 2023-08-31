output "ecr_repository_url" {
  value = {
    repository_url = aws_ecr_repository.default.repository_url
    repository_arn = aws_ecr_repository.default.arn
    registry_id    = aws_ecr_repository.default.registry_id
  }
}

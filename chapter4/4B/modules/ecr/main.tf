# Fetch account ID of the current organisation
data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "default" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    env               = "${var.environment}"
    terraform-managed = "true"
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    sid    = "ECRs4cpRepoPolicy${var.environment}"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.id}:role/AssumeRoleECRWithoutMFA${var.environment}"
      ]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "default" {
  repository = aws_ecr_repository.default.name
  policy     = data.aws_iam_policy_document.default.json
}


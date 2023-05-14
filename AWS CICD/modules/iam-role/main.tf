resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
      {
        Effect = "Allow"
        Principal = {
            Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
            Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_codebuild_project" "codebuild_project" {
  name = "coebuild_project"
  service_role = var.role_arn
  tags = "terraform_codebuild_tag"
  artifacts {
    type = CODEPIPELINE
  }
  environment {
    type = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_SMALL" 
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    image_pull_credentials_type = "CODEBUILD"
  }
}
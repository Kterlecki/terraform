resource "aws_codepipeline" "terraform_pipeline" {
  name = "terraform_pipeline"
  role_arn = module.aws_iam_role.codepipeline_role.arn
  tags = "codepipeline_tag"

  artifact_store {
    location = "module.artifact_bucket.bucket"
    type = "S3"

  }
}
terraform {
  required_version = ">= 1.0.0"
}

module "artifact_bucket" {
    source                  = "./modules/S3"
    project_name            = "test_project_module"
    codepipeline_role_arn   = ""

    tags = {
        Project_Name        = "test_project_module_t"
    }
}

module "codebuild_terraform" {
  source = "./modules/codebuild"

  project_name = "test_project_module"
  role_arn = module.codepipeline_iam_role.role_arn
  s3_bucket_name = module.artifact_bucket.bucket
  build_project_source = "GITHUB"
  builder_compute_type = "BUILD_GENERAL1_SMALL"
  builder_image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  builder_image_pull_credentials_type = "CODEBUILD"
  builder_type = "LINUX_CONTAINER"
  tags = {
    Project_Name = "test_project_module_t"
  }
}


module "codepipeline_iam_role" {
  source                      = "./modules/iam-role"
  project_name                = "test_project_module"
  codepipeline_iam_role_name  = var.codepipeline_iam_role_name
  s3_bucket_arn               = module.artifact_bucket.arn
  tags = {
    Project_Name              = "test_project_module_t"
  }
  
}
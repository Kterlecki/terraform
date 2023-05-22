terraform {
  required_version = ">= 1.0.0"
}

module "artifact_bucket" {
    source                  = "./modules/S3"
    project_name            = "test_project_module"
    codepipeline_role_arn   = ""

    tags = {
        Project_Name        = "test_project_module"
    }
}

module "codepipeline_iam_role" {
  source                      = "./modules/iam-role"
  project_name                = "test_project_module"
  codepipeline_iam_role_name  = var.codepipeline_iam_role_name
  s3_bucket_arn               = module.artifact_bucket.arn
  tags = {
    Project_Name              = "test_project_module"
  }
  
}
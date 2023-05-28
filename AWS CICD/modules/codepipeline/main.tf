resource "aws_codepipeline" "terraform_pipeline" {
  name = "terraform_pipeline"
  role_arn = module.aws_iam_role.codepipeline_role.arn
  tags = "codepipeline_tag"

  artifact_store {
    location = "module.artifact_bucket.bucket"
    type = "S3"

  }

  stage {
    name = "Source"
    action {
      name = "Download source"
      category = "Source"
      owner = "AWS"
      version = "1"
      provider = "S3"
      output_artifacts = [ "source_output" ]
      run_order = 1
      configuration = {
        S3Bucket = "s3-bucket-kt"
        S3ObjectKey = "hello-world"
        PollForSourceChanges = "true"
      }
    }
  }
  stage {
    name = "Build"
    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [ "source_output" ]
      output_artifacts = [ "build_output" ]
      version = "1"
      run_order = 2
      configuration = {
        ProjectName = "hello-world"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      input_artifacts = [ "build_output" ]
      version = "1"
      configuration = {
        ApplicationName = "hello-world-s3"
        DeploymentGroupName = "hello-world-s3-dg"
      }
    }
  }
}


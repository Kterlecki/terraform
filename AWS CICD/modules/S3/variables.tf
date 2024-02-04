variable "codepipeline_role_arn" {
  description = "ARN of codePipeline IAM role"
  type        = string
}

variable "project_name" {
  description = "Name of the project to be prefixed - s3 bucket"
}
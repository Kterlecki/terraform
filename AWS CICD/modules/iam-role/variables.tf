variable "codepipeline_iam_role_name" {
    description = "Name of the IAM role to be used for this project"
    type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of S3 bucket"
  type = string
}
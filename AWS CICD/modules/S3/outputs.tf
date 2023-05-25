output "arn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
  description = "The Arn of the S3 bucket"
}

output "bucket" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
  description = "Name of the S3 bucket"
}

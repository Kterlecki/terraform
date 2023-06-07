output "arn" {
  value = aws_s3_bucket.codepipeline-bucket-84543422.arn
  description = "The Arn of the S3 bucket"
}

output "bucket" {
  value = aws_s3_bucket.codepipeline-bucket-84543422.bucket
  description = "Name of the S3 bucket"
}

output "s3_bucket_name" {
  value       = module.s3_artifact_bucket.bucket
  description = "The Name of the S3 Bucket"
}
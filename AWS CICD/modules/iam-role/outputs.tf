output "role_arn" {
  value       = aws_iam_role.codepipeline_role.arn
  description = "Arn of the IAM role - Codepipeline"
}

output "role_name" {
  value       = aws_iam_role.codepipeline_role.name
  description = "Name of the IAM role"
}
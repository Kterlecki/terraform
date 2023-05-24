output "arn" {
  value = aws_codebuild_project.codebuild_project[*].arn
  description = "List of Arns of the Codebuild projects"
}
output "id" {
  value = aws_codebuild_project.codebuild_project[*].id
  description = "List of IDs of the Codebuild projects"
}

output "name" {
  value       = aws_codebuild_project.terraform_codebuild_project[*].name
  description = "List of Names of the CodeBuild projects"
}
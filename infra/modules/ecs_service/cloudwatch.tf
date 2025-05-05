resource "aws_cloudwatch_log_group" "main" {
  name              = module.label.name
  retention_in_days = 30
}
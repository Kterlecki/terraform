output "ecs_service_arn" {
  value = aws_ecs_service.ecs_service.id
}

output "security_group_id" {
  value = aws_security_group.ecs_service_sg.id
}

output "ecs_log_group_name" {
  value = aws_cloudwatch_log_group.main.name
}

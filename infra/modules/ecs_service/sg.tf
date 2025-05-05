resource "aws_security_group" "ecs_service_sg" {
  name        = module.label_sg.name
  description = "security group for control traffic to ${module.label.name} ECS service"
  vpc_id      = var.vpc_id
  tags        = module.label_sg.tags
  lifecycle {
    create_before_destroy = true
  }
}
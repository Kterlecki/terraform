resource "aws_ecs_service" "ecs_service" {
  name                 = module.label.name
  cluster              = var.ecs_cluster_id
  task_definition      = aws_ecs_task_definition.task_definition.arn
  desired_count        = var.desired_count
  force_new_deployment = true
  launch_type          = "FARGATE"

  dynamic "load_balancer" {
    // Does not create the load balancer if the load_balancer is not specified
    for_each = var.load_balancer_group_arn == null ? [] : [var.load_balancer_group_arn]

    content {
      target_group_arn = var.load_balancer_group_arn
      container_name   = module.label_container.name
      container_port   = var.container_port
    }

    network_configuration {
      subnets          = var.subnet_ids
      security_groups  = [aws_security_group.ecs_service_sg.id]
      assign_public_ip = false
    }

    deployment_circuit_breaker {
      enable   = true
      rollback = false
    }
  }
}
resource "aws_ecs_task_definition" "task_definition" {
  family                   = module.label_ecstask.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecr_taskexecution_role_arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = module.label_container.name,
      image     = var.container_image,
      cpu       = var.task_cpu,
      memory    = var.task_memory,
      essential = true,
      environment = [
        for key, value in var.envvars :
        { "name" = key, "value" = value }
      ],
      secrets = [
        for key, arn in var.secrets :
        { "name" = key, "valueFrom" = arn }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.main.name,
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = aws_cloudwatch_log_group.main.name
        }
      },
      portMappings = local.portMappings
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  tags = module.label_ecstask.tags
}

locals {
  portMappings = var.container_port == null ? null : [{ containerPort = var.container_port }]
}

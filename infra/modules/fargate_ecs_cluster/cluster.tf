resource "aws_ecs_cluster" "ecs_cluster" {
  name = module.label.name

# Enable "Container Insights" for CloudWatch monitoring
    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}

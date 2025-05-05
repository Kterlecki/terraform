resource "aws_iam_role" "ecr_task_execution_role" {
  name                 = module.label_ecs_execution_role.name
  assume_role_policy   = data.aws_iam_policy_document.ecs_tasks_assume_role_policy_document.json
  permissions_boundary = var.permissions_boundary_arn
}

data "aws_iam_policy_document" "ecs_tasks_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  role       = aws_iam_role.ecr_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name   = module.label_ecs_execution_role.name
  policy = data.aws_iam_policy_document.ecs_task_execution_policy_document.json
}
data "aws_iam_policy_document" "ecs_task_execution_policy_document" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt",
      "secretsmanager:GetSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

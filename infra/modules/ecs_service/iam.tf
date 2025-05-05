resource "aws_iam_role" "ecs_task_role" {
  name               = module.label_task_aws_access_role.name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy_document.json
  tags               = module.label_task_aws_access_role.tags
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_role_access_resource_policy" {
  count = length(var.task_role_policy_statements) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.task_role_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }
}

resource "aws_iam_policy" "ecs_task_role_access_resource_policy" {
  count  = length(var.task_role_policy_statements) > 0 ? 1 : 0
  name   = module.label_task_aws_access_policy.name
  policy = data.aws_iam_policy_document.ecs_task_role_access_resource_policy[0].json
  tags   = module.label.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_access_resource_policy_attach" {
  count      = length(var.task_role_policy_statements) > 0 ? 1 : 0
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_access_resource_policy[0].arn
}

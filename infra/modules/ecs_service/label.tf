module "label" {
    source = "../../label"
    type        = var.type
    project     = var.project
    attribute   = var.attribute
    environment = var.environment
}

module "label_ecstask" {
  source  = "../label"
  context = module.label.context
  type    = "ecstask"
}

# to highlight current 1-1 relationship between our ecstask and container we inherit the container label from ecstask one
module "label_container" {
  source    = "../label"
  context   = module.label_ecstask.context
  attribute = "container"
}

module "label_task_aws_access_role" {
  source    = "../label"
  context   = module.label.context
  type      = "role"
  attribute = "${var.purpose}-aws-access"
}

module "label_task_aws_access_policy" {
  source  = "../label"
  context = module.label_task_aws_access_role.context
  type    = "policy"
}

module "label_sg" {
  source    = "../label"
  context   = module.label.context
  attribute = "sg"
}

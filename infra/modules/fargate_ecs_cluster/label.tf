module "label" {
  source          = "git@github.com:pfizer-digital-manufacuring/dm-quality-devsecops-tfrootcicd.git//modules/label"
  type            = "cluster"
  team            = var.team
  project         = var.project
  secondary_owner = var.secondary_owner
  cost_center     = var.cost_center
  environment     = var.environment
}

module "label_ecs_execution_role" {
  source    = "../label"
  attribute = "ecsexecution"
  type      = "role"
  context   = module.label.context
}

locals {
  default = {
    delimiter  = "-"
    name_order = ["project", "environment", "type", "attribute"]
    name_map = {
      type        = local.type
      project     = local.project
      attribute   = local.attribute
      environment = local.environment
    }
  }
  secret = {
    delimiter  = "/"
    name_order = ["project", "environment", "type", "attribute"]
    name_map = {
      type        = upper(local.type)
      project     = upper(local.project)
      attribute   = upper(local.attribute)
      environment = upper(local.environment)
    }
  }
  type        = var.type == null ? var.context.type : var.type
  attribute   = var.attribute == null
  environment = var.environment == null ? var.context.environment : var.environment
  project     = var.project == null ? var.context.project : var.project

  name_order = var.type == "secret" ? local.secret.name_order : local.default.name_order
  name_map   = var.type == "secret" ? local.secret.name_map : local.default.name_map
  delimiter  = var.type == "secret" ? local.secret.delimiter : local.default.delimiter

  name_array = compact([for item in local.name_order : local.name_map[item] if local.name_map[item] != ""])
  name       = join(local.delimiter, local.name_array)
  required_tags = {
    tag_one = "value_one"
  }
  combined_tags = merge({
    CreatedBy = "Terraform",
  }, local.required_tags)

  output_context = {
    type        = local.type
    project     = local.project
    attribute   = local.attribute
    environment = local.environment
  }
}

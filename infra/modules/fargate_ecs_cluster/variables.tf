variable "project" {
  type        = string
  description = "Project name"
}

variable "type" {
  type        = string
  description = "Type of the resource"
}

variable "attribute" {
  type        = string
  description = "Attribute of the resource"
}

variable "environment" {
  type        = string
  description = "Environment of the resource"
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN of the permissions boundary to use for the ECS task role"
}

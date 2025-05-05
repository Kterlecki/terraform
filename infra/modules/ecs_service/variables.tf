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

variable "load_balancer_group_arn" {
  description = "Load balancer to be used. Default value of null does not create a load balancer for the ecs service."
  type        = string
  default     = null
}
variable "purpose" {
  type        = string
  description = "Purpose of the ecs service - backend-api or frontend"
}
variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "desired_count" {
  description = "Number of tasks run by the ECS service."
  type        = string
}

variable "task_cpu" {
  description = "CPU to allocate"
  type        = number
}

variable "task_memory" {
  description = "Memory to allocate."
  type        = number
}

variable "container_port" {
  description = "Port to use. Default value of null disables port mapping in the task definition."
  type        = number
  default     = null
}

variable "container_image" {
  description = "Container image to use."
  type        = string
}

variable "ecr_taskexecution_role_arn" {
  description = "ARN for the task execution role."
  type        = string
}

variable "secrets" {
  type        = map(string)
  description = "A dictionary which's Key is an name of envvar (like BACKEND_API_URL) and Value is the arn of AWS secret manager secret, from where the value going to be added to ECS"
}

variable "envvars" {
  type        = map(string)
  description = "A dictionary which's Key is an name of envvar (like BACKEND_API_CONTAINER_PORT) and Value is the value given for that variable, from where the value going to be added to ECS container"
}

variable "task_role_policy_statements" {
  type        = any
  description = "A list of policy statements to allow the ecs task to access AWS resources. This is what the container application will use."
  default     = []
}

variable "subnet_ids" {
  description = "Subnet ids to use"
  type        = list(string)
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

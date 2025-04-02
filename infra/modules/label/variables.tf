variable "type" {
  type        = string
  default     = null
  description = "When type='secret' label's name produces secret's path for AWS secretsmanager"
}

variable "attribute" {
  type    = string
  default = null
}
variable "environment" {
  type    = string
  default = null
}
variable "project" {
  type    = string
  default = null
}

variable "context" {
  type = object({
    type        = string
    project     = string
    attribute   = string
    environment = string
  })
  default     = null
  description = "Alternate method of creating label by inheriting from another label."
}

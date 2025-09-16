variable "organization" {
  description = "The name of the Terraform Cloud organization."
  type        = string
}

variable "project" {
  description = "The name of the Terraform Cloud project."
  type        = string
}

variable "participant_name" {
  description = "The name of the participant."
  type        = string
}

locals {
  sanitized_name = replace(var.participant_name, " ", "_")
  first_name     = lower(split(" ", var.participant_name)[0])
}

resource "tfe_workspace" "dev" {
  name         = "${local.sanitized_name}_dev"
  organization = var.organization
  project_id   = var.project
  tag_names    = [local.first_name]
}

resource "tfe_workspace" "pro" {
  name         = "${local.sanitized_name}_pro"
  organization = var.organization
  project_id   = var.project
  tag_names    = [local.first_name]
}

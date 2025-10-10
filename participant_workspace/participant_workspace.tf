
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
  _split_name    = split(" ", var.participant_name)
  first_name     = lower(local._split_name[0])
}

resource "tfe_workspace" "dev" {
  name         = "${local.sanitized_name}_dev"
  organization = var.organization
  project_id   = var.project
  force_delete = true
  tag_names    = [local.first_name, "iac_intro_workshop"]
}

resource "tfe_variable" "dev_environment" {
  key          = "environment"
  value        = "dev"
  category     = "terraform"
  workspace_id = tfe_workspace.dev.id
  sensitive    = false
}

resource "tfe_workspace" "pro" {
  name         = "${local.sanitized_name}_pro"
  organization = var.organization
  project_id   = var.project
  force_delete = true
  tag_names    = [local.first_name, "iac_intro_workshop"]
}

resource "tfe_variable" "pro_environment" {
  key          = "environment"
  value        = "pro"
  category     = "terraform"
  workspace_id = tfe_workspace.pro.id
  sensitive    = false
}



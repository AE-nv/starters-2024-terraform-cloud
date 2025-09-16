variable "organization" {
  description = "The name of the Terraform Cloud organization."
  type        = string
}

variable "project" {
  description = "The name of the Terraform Cloud project."
  type        = string
}

variable "team_id" {
  description = "The ID of the team to add the participant to."
  type        = string
}

variable "participant_name" {
  description = "The name of the participant."
  type        = string
}

locals {
  sanitized_name = replace(var.participant_name, " ", "_")
  _split_name    = split(" ", var.participant_name)
  first_name     = local._split_name[0]
  last_name      = join("", slice(local._split_name, 1, length(local._split_name)))
}

resource "tfe_workspace" "dev" {
  name         = "${local.sanitized_name}_dev"
  organization = var.organization
  project_id   = var.project
  tag_names    = [lower(local.first_name)]
}

resource "tfe_workspace" "pro" {
  name         = "${local.sanitized_name}_pro"
  organization = var.organization
  project_id   = var.project
  tag_names    = [lower(local.first_name)]
}

resource "tfe_organization_membership" "membership" {
  organization = var.organization
  email        = "${local.first_name}.${local.last_name}@ae.be"
}

resource "tfe_team_organization_member" "team_member" {
  team_id                    = var.team_id
  organization_membership_id = tfe_organization_membership.membership.id
}

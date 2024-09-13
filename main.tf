# main.tf

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.58.1"
    }
  }
  
  cloud {
    organization = "AE_nv"
    workspaces {
      name = "AE_starters_remote_backend"
    }
  }
}


provider "tfe" {
  # Configure the provider here (e.g., with a token)
  token = var.tfe_token
}

data "tfe_organization" "org" {
  name = var.organization_name
  #email = var.organization_email
}

resource "tfe_project" "projects" {
  for_each     = { for project in var.projects : project.name => project }
  name         = each.value.name
  organization = data.tfe_organization.org.name
}

resource "tfe_workspace" "workspaces" {
  for_each     = { for workspace in local.flattened_workspaces : "${workspace.project_name}.${workspace.name}" => workspace }
  name         = each.value.name
  organization = data.tfe_organization.org.name
  project_id   = tfe_project.projects[each.value.project_name].id
}


# variables.tf

variable "organization_name" {
  description = "Name of the Terraform Cloud organization"
  type        = string
}

variable "organization_email" {
  description = "Email for the Terraform Cloud organization"
  type        = string
}

variable "projects" {
  description = "List of projects and their workspaces"
  type = list(object({
    name       = string
    workspaces = list(string)
  }))
}

variable "tfe_token" {
  description = "token to access TF enterprise"
  type        = string
  sensitive   = true
}

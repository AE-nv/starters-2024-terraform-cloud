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
      name = "AE_starters_workspace_remote_backend"
      project = "AE_starters_project_tf_backend"
    }
  }

}

data "tfe_organization" "org" {
  name = var.organization_name
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
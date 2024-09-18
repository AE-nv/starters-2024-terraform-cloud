terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.58.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-starters-tfstate-weu-01"
    storage_account_name = "ststarterstfstateweu01"
    container_name       = "cont-starters-tfstate-weu-01"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}

data "tfe_organization" "org" {
  name = "AE_nv"
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
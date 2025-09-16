
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

data "tfe_variable_set" "tfe_variable_sets" {
  for_each     = var.variable_set_names
  name         = each.value
  organization = data.tfe_organization.org.name
}

data "tfe_team" "owners" {
  name         = "owners"
  organization = data.tfe_organization.org.name
}

resource "tfe_project" "starters_project" {
  name         = "AE_IAC_Intro_Workshop"
  organization = data.tfe_organization.org.name
}

module "participant_workspaces" {
  source   = "./participant_workspace"
  for_each = var.participants

  participant_name = each.value
  organization     = data.tfe_organization.org.name
  project          = resource.tfe_project.starters_project.id
  team_id          = data.tfe_team.owners.id
}

resource "tfe_project_variable_set" "link_variable_sets" {
  for_each        = data.tfe_variable_set.tfe_variable_sets
  project_id      = resource.tfe_project.starters_project.id
  variable_set_id = each.value.id
}

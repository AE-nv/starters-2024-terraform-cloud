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

resource "tfe_project" "starters_project" {
  name         = "AE_starters_project_iac"
  organization = data.tfe_organization.org.name
}

module "participant_workspaces" {
  source        = "./participant_workspace"
  for_each      = var.participants

  participant_name = each.value
  organization  = data.tfe_organization.org.name
  project       = resource.tfe_project.starters_project.id
}
# main.tf

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.42.0"
    }
  }


  backend "remote" {
    organization = "my-org"
    workspaces {
      name = "terraform-cloud-workspace"
    }
  }
}


provider "tfe" {
  # Configure the provider here (e.g., with a token)
  # token = var.tfe_token
}

resource "tfe_organization" "org" {
  name  = var.organization_name
  email = var.organization_email
}

resource "tfe_workspace" "workspace" {
  count        = length(var.workspace_names)
  name         = var.workspace_names[count.index]
  organization = tfe_organization.org.name
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

variable "workspace_names" {
  description = "List of workspace names to create"
  type        = list(string)
}

# terraform.tfvars

organization_name  = "my-org"
organization_email = "admin@example.com"
workspace_names    = ["dev", "staging", "prod"]

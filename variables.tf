variable "organization_name" {
  description = "Name of the Terraform Cloud organization"
  type        = string
}

variable "projects" {
  description = "List of projects and their workspaces"
  type = list(object({
    name       = string
    workspaces = list(string)
  }))
}
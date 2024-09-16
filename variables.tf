variable "projects" {
  description = "List of projects and their workspaces"
  type = list(object({
    name       = string
    workspaces = list(string)
  }))
}
variable "projects" {
  description = "List of projects and their workspaces"
  type = list(object({
    name       = string
    workspaces = list(object({
      name     = string
      tag_names = list(string)
    }))
  }))
}
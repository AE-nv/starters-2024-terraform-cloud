locals {
  flattened_workspaces = flatten([
    for project in var.projects : [
      for workspace in project.workspaces : {
        project_name = project.name
        name         = workspace.name
        tag_names    = workspace.tag_names
      }
    ]
  ])
}
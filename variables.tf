variable "participants" {
  description = "List of participants"
  type        = set(string)
}


variable "variable_set_names" {
  description = "Names of the variable sets to fetch."
  type        = set(string)
}

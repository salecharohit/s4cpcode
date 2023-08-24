variable "roles" {
  description = "List of Roles that need to be attached"
  type        = list(string)
}

variable "username" {
  description = "Username of Service Account User"
  type        = string
}
variable "project_name" {
  description = "Name stored in the learning resource."
  type        = string
  default     = "devops-lab2"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.project_name))
    error_message = "Use a lowercase name starting with a letter."
  }
}

variable "environment" {
  description = "Learning environment label."
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging or production."
  }
}

terraform {
  required_version = ">= 1.4.0, < 2.0.0"
}

# Built-in resource: stores metadata without provisioning cloud infrastructure.
resource "terraform_data" "lab" {
  input = {
    project_name = var.project_name
    environment  = var.environment
  }
}

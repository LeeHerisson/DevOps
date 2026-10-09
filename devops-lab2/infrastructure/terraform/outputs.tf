output "lab_metadata" {
  description = "Metadata stored by the built-in terraform_data resource."
  value       = terraform_data.lab.output
}

output "role_definition_id" {
  description = "The ID of the role definition."
  value       = module.role_definitions.role_definition_rolename_to_resource_id["Storage Blob Data Contributor"]
}

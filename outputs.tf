output "role_definition_rolename_to_name" {
  description = "A map of role definition role names, e.g. 'Contributor', to role definition IDs."
  value       = local.role_definitions_map
}

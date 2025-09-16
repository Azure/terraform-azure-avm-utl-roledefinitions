output "role_definition_rolename_to_name" {
  value       = local.role_definitions_map
  description = "A map of role definition role names, e.g. 'Contributor', to role definition IDs."
}

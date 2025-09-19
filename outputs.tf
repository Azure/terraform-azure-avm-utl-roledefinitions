output "role_definition_rolename_to_name" {
  description = "A map of role definition role names, e.g. 'Contributor', to role definition names (UUIDs)."
  value       = { for k, v in local.role_definitions_map : k => v.name }
}

output "role_definition_rolename_to_resource_id" {
  description = <<DESCRIPTION
A map of role definition role names, e.g. 'Contributor', to role definition resource IDs.
The resource ID returned will be tenant scoped or subscription scoped, depending on the value of the `role_definition_scope` input variable.

- If the `role_definition_scope` input variable is not set, the resource ID will be subscription scoped.
- If the `role_definition_scope` input variable is set to a management group, the resource ID will be tenant scoped.
- If the `role_definition_scope` input variable is set to a subscription, the resource ID will be subscription scoped.
DESCRIPTION
  value       = { for k, v in local.role_definitions_map : k => v.id }
}

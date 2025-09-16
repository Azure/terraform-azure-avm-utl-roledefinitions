output "role_definitions_cached" {
  description = "The cached list of role definitions from the API. Output is a list of role definition objects under the `value` key."
  value       = local.role_definitions_cached
}

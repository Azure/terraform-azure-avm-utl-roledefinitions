output "role_definitions_cached" {
  description = "The cached list of built-in role definitions from the API. Output is an object with key `value` containing a list of minimal role objects: { name, roleName }."
  value       = local.role_definitions_cached
}

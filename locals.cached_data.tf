# Implement an anti-corruption layer to transform the data from the Azure API into a format that is easier to work with in the rest of the module.
locals {
  cached_role_definitions_map = {
    for role_definition in module.cached_data.role_definitions_cached.value :
    role_definition.properties.roleName => role_definition.name
  }
}

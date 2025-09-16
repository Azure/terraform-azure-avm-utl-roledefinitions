# Implement an anti-corruption layer to transform the data from the Azure API into a format that is easier to work with in the rest of the module.
locals {
  live_role_definitions_map = var.use_cached_data ? {} : {
    for role_definition in data.azapi_resource_list.role_definitions[0].output.value :
    role_definition.properties.roleName => role_definition.name
  }
}

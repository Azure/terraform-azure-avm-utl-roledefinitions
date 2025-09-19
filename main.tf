data "azapi_client_config" "current" {}

module "cached_data" {
  source = "./modules/cached-data"
}

data "azapi_resource_list" "role_definitions" {
  count = var.use_cached_data ? 0 : 1

  parent_id              = coalesce(var.role_definition_scope, data.azapi_client_config.current.subscription_resource_id)
  type                   = "Microsoft.Authorization/roleDefinitions@2022-04-01"
  response_export_values = ["value"]
}

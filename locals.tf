# role_definitions is the source data set, either from a cache or live data.
locals {
  role_definitions_map = var.use_cached_data ? local.cached_role_definitions_map : local.live_role_definitions_map
}

locals {
  role_definition_output_scope_prefix   = local.role_definition_scope_is_subscription ? regex("^/subscriptions/[0-9a-fA-F-]{36}", coalesce(var.role_definition_scope, data.azapi_client_config.current.subscription_resource_id)) : ""
  role_definition_scope_is_subscription = var.role_definition_scope == null || can(regex("^/subscriptions/[0-9a-fA-F-]{36}$", var.role_definition_scope))
}

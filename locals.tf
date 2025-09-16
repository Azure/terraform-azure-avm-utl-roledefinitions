# role_definitions is the source data set, either from a cache or live data.
locals {
  role_definitions_map = var.use_cached_data ? local.cached_role_definitions_map : local.live_role_definitions_map
}

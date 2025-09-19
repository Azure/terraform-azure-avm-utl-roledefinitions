variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "role_definition_scope" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Serves two purposes. First, if using live data, it defines the scope at which to fetch role definitions.
Second it prepends the scope to the role definition ID output, this will be either the tenant root scope or a subscription scope - see output documentation.
DESCRIPTION

  validation {
    condition     = var.role_definition_scope == null || can(regex("^/subscriptions/[0-9a-fA-F-]{36}", var.role_definition_scope)) || can(regex("^/providers/Microsoft.Management/managementGroups/[a-zA-Z0-9-_.]{1,64}$", var.role_definition_scope))
    error_message = "value must be a valid Azure resource ID or null"
  }
}

variable "use_cached_data" {
  type        = bool
  default     = true
  description = "If true, use the cached role definition data. If false, fetch live data from Azure."
  nullable    = false
}

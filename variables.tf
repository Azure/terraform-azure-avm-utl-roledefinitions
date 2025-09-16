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

variable "use_cached_data" {
  type        = bool
  default     = true
  description = "If true, use the cached role definition data. If false, fetch live data from Azure."
  nullable    = false
}

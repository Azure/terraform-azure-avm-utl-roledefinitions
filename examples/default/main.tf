terraform {
  required_version = "~> 1.6"

  required_providers {
  }
}

module "role_definitions" {
  source = "../../"

  enable_telemetry = var.enable_telemetry
}

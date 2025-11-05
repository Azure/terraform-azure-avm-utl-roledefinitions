terraform {
  required_version = "~> 1.6"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

data "azapi_client_config" "current" {}

resource "random_pet" "suffix" {
  length    = 2
  separator = "-"
}

resource "random_uuid" "role_assignment_name" {}

module "role_definitions" {
  source = "../../"

  enable_telemetry      = var.enable_telemetry
  role_definition_scope = azapi_resource.resource_group.id
  use_cached_data       = false
}

resource "azapi_resource" "resource_group" {
  location  = "swedencentral"
  name      = "rg-${random_pet.suffix.id}"
  parent_id = data.azapi_client_config.current.subscription_resource_id
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
}

resource "azapi_resource" "example_role_assignment" {
  name      = random_uuid.role_assignment_name.result
  parent_id = azapi_resource.resource_group.id
  type      = "Microsoft.Authorization/roleAssignments@2022-04-01"
  body = {
    properties = {
      roleDefinitionId = module.role_definitions.role_definition_rolename_to_resource_id["Storage Blob Data Contributor"]
      principalId      = data.azapi_client_config.current.object_id
      principalType    = null
    }
  }
  # required to ignore the service setting principalType and resulting
  # in perpetual diffs.
  ignore_null_property   = true
  response_export_values = []
}

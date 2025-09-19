# Azure Role Definitions Module

This module outputs a simple map of role definition role names to UUIDs and resource IDs.
It rationalizes the resource ID to be either tenant root scoped or subscription scoped, depending on the input variable `role_definition_scope`. This helps with getting idempotent role assignment resources.

There is an option to use live data from Azure or cached data within the module, which is updated regularly with built-in roles.

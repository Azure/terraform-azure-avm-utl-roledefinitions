run "cached_role_definitions" {
  command = apply

  assert {
    condition     = length(output.role_definitions_cached.value) > 0
    error_message = "The bundled snapshot must contain role definitions."
  }

  assert {
    condition     = length(toset([for role in output.role_definitions_cached.value : role.name])) == length(output.role_definitions_cached.value)
    error_message = "Each cached role definition must have a unique identifier."
  }

  assert {
    condition = {
      for role in output.role_definitions_cached.value : role.roleName => role.name
      if contains(["Contributor", "Owner", "Reader"], role.roleName)
      } == {
      Contributor = "b24988ac-6180-42a0-ab88-20f7382dd24c"
      Owner       = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
      Reader      = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
    }
    error_message = "The cached Contributor, Owner, and Reader roles must retain their built-in identifiers."
  }
}

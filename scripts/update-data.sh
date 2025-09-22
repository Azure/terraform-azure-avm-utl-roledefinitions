#!/usr/bin/env bash
set -euo pipefail

# Regenerate the cached built-in role definitions file with a minimal object shape: { name, roleName }.
# This mirrors the GitHub Actions workflow logic but makes it easy to run locally.
#
# Prerequisites:
#   - Azure CLI (az) logged in (az login) with access to the target subscription
#   - jq installed
#   - (Optional) jd installed for deep structural diff output
#
# Usage:
#   ./scripts/update-data.sh                 # auto-detects current az account subscription
#   ARM_SUBSCRIPTION_ID=<sub_id> ./scripts/update-data.sh
#   AZ_API_VERSION=2022-04-01 ./scripts/update-data.sh
#
# Environment Variables:
#   ROLE_DEFINITIONS_CACHE (default: modules/cached-data/role_definitions.tf.json)
#   ARM_SUBSCRIPTION_ID     (if unset, script derives via `az account show`)
#   AZ_API_VERSION         (default: 2022-04-01)
#
# Exit codes:
#   0 success (updated or no change)
#   non-zero on error

ROLE_DEFINITIONS_CACHE="${ROLE_DEFINITIONS_CACHE:-modules/cached-data/role_definitions.tf.json}"
AZ_API_VERSION="${AZ_API_VERSION:-2022-04-01}"

if ! command -v az >/dev/null 2>&1; then
  echo "[error] az CLI not found in PATH" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "[error] jq not found in PATH" >&2
  exit 1
fi

if [[ -z "${ARM_SUBSCRIPTION_ID:-}" ]]; then
  ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || true)
  if [[ -z "$ARM_SUBSCRIPTION_ID" ]]; then
    echo "[error] Could not determine subscription. Set ARM_SUBSCRIPTION_ID explicitly." >&2
    exit 1
  fi
  echo "[info] Using detected subscription: $ARM_SUBSCRIPTION_ID"
else
  echo "[info] Using subscription from env: $ARM_SUBSCRIPTION_ID"
fi

# Backup existing file if present
if [[ -f "$ROLE_DEFINITIONS_CACHE" ]]; then
  cp "$ROLE_DEFINITIONS_CACHE" "$ROLE_DEFINITIONS_CACHE.original"
  echo "[info] Backed up existing cache to $ROLE_DEFINITIONS_CACHE.original"
fi

TMP_FILE="${ROLE_DEFINITIONS_CACHE}.tmp"

echo "[info] Fetching role definitions from Azure..."
az rest --method GET \
  --uri "/subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions?api-version=${AZ_API_VERSION}" \
  | jq '{ "locals": { "role_definitions_cached": {"value": ( .value | map(select(.properties.type == "BuiltInRole") | { name: .name, roleName: .properties.roleName }) ) }}}' \
  > "$TMP_FILE"

# Replace target file
cp "$ROLE_DEFINITIONS_CACHE" "$ROLE_DEFINITIONS_CACHE.original"
mv "$TMP_FILE" "$ROLE_DEFINITIONS_CACHE"
echo "[info] Wrote updated cache to $ROLE_DEFINITIONS_CACHE"

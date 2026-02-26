#!/bin/bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════════════
# AssetManager – Bicep Deployment Script
# Provisions infrastructure, builds Docker images, and deploys container apps.
#
# Usage:
#   ./infra/deploy.sh -e <environment> -l <location> [-p <pg-password>]
#
# Example:
#   ./infra/deploy.sh -e assetsmgr -l eastus2
# ═══════════════════════════════════════════════════════════════════════════════

ENVIRONMENT_NAME=""
LOCATION="eastus2"
PG_PASSWORD=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

usage() {
  echo "Usage: $0 -e <environment-name> -l <location> [-p <postgres-password>]"
  echo "  -e  Environment name (used as prefix for all resources)"
  echo "  -l  Azure region (default: eastus2)"
  echo "  -p  PostgreSQL admin password (auto-generated if omitted)"
  exit 1
}

while getopts "e:l:p:h" opt; do
  case $opt in
    e) ENVIRONMENT_NAME="$OPTARG" ;;
    l) LOCATION="$OPTARG" ;;
    p) PG_PASSWORD="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done

if [[ -z "$ENVIRONMENT_NAME" ]]; then
  echo "Error: -e <environment-name> is required."
  usage
fi

# Generate a random password if not provided
if [[ -z "$PG_PASSWORD" ]]; then
  PG_PASSWORD="Pg$(openssl rand -base64 18 | tr -dc 'A-Za-z0-9' | head -c 16)!"
  echo "Generated PostgreSQL admin password (save it securely)."
fi

DEPLOYMENT_NAME="deploy-${ENVIRONMENT_NAME}-$(date +%s)"

echo "═══════════════════════════════════════════════════════════"
echo " AssetManager Bicep Deployment"
echo "═══════════════════════════════════════════════════════════"
echo " Environment : $ENVIRONMENT_NAME"
echo " Location    : $LOCATION"
echo " Project Dir : $PROJECT_DIR"
echo "═══════════════════════════════════════════════════════════"

# ── Prerequisites ────────────────────────────────────────────────────────────

echo ""
echo "▸ Checking prerequisites..."
for cmd in az docker; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "  ✗ '$cmd' not found. Please install it."
    exit 1
  fi
  echo "  ✓ $cmd"
done

echo ""
echo "▸ Verifying Azure login..."
SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null) || {
  echo "  ✗ Not logged in. Run 'az login' first."
  exit 1
}
echo "  ✓ Subscription: $SUBSCRIPTION_ID"

# ── Register providers ──────────────────────────────────────────────────────

echo ""
echo "▸ Registering resource providers..."
for provider in Microsoft.DBforPostgreSQL Microsoft.App Microsoft.ServiceBus Microsoft.ContainerRegistry; do
  az provider register --namespace "$provider" --wait --only-show-errors
  echo "  ✓ $provider"
done

# ── Validate Bicep template ─────────────────────────────────────────────────

echo ""
echo "▸ Validating Bicep template (what-if)..."
az deployment sub what-if \
  --name "${DEPLOYMENT_NAME}-whatif" \
  --location "$LOCATION" \
  --template-file "${SCRIPT_DIR}/main.bicep" \
  --parameters environmentName="$ENVIRONMENT_NAME" \
               location="$LOCATION" \
               postgresAdminPassword="$PG_PASSWORD" \
  --no-prompt \
  --only-show-errors
echo "  ✓ Validation passed"

# ── Deploy infrastructure ───────────────────────────────────────────────────

echo ""
echo "▸ Deploying infrastructure (this may take 10-15 minutes)..."
DEPLOY_OUTPUT=$(az deployment sub create \
  --name "$DEPLOYMENT_NAME" \
  --location "$LOCATION" \
  --template-file "${SCRIPT_DIR}/main.bicep" \
  --parameters environmentName="$ENVIRONMENT_NAME" \
               location="$LOCATION" \
               postgresAdminPassword="$PG_PASSWORD" \
  --query 'properties.outputs' \
  --output json \
  --only-show-errors)

# Extract outputs
RG_NAME=$(echo "$DEPLOY_OUTPUT" | jq -r '.RESOURCE_GROUP_NAME.value')
ACR_NAME=$(echo "$DEPLOY_OUTPUT" | jq -r '.ACR_NAME.value')
ACR_LOGIN_SERVER=$(echo "$DEPLOY_OUTPUT" | jq -r '.ACR_LOGIN_SERVER.value')
WEB_APP_NAME=$(echo "$DEPLOY_OUTPUT" | jq -r '.WEB_APP_NAME.value')
WORKER_APP_NAME=$(echo "$DEPLOY_OUTPUT" | jq -r '.WORKER_APP_NAME.value')
WEB_APP_URL=$(echo "$DEPLOY_OUTPUT" | jq -r '.WEB_APP_URL.value')

echo "  ✓ Infrastructure deployed"
echo "    Resource Group  : $RG_NAME"
echo "    ACR             : $ACR_LOGIN_SERVER"

# ── Build Maven project ─────────────────────────────────────────────────────

echo ""
echo "▸ Building Maven project..."
cd "$PROJECT_DIR"
./mvnw clean package -DskipTests -q
echo "  ✓ Maven build complete"

# ── Build & push Docker images via ACR ───────────────────────────────────────

echo ""
echo "▸ Building web Docker image in ACR..."
az acr build \
  --registry "$ACR_NAME" \
  --image "${WEB_APP_NAME}:latest" \
  --file ./web/Dockerfile \
  . \
  --only-show-errors
echo "  ✓ Web image pushed"

echo ""
echo "▸ Building worker Docker image in ACR..."
az acr build \
  --registry "$ACR_NAME" \
  --image "${WORKER_APP_NAME}:latest" \
  --file ./worker/Dockerfile \
  . \
  --only-show-errors
echo "  ✓ Worker image pushed"

# ── Update Container Apps with real images ───────────────────────────────────

echo ""
echo "▸ Updating web Container App image..."
az containerapp update \
  --resource-group "$RG_NAME" \
  --name "$WEB_APP_NAME" \
  --image "${ACR_LOGIN_SERVER}/${WEB_APP_NAME}:latest" \
  --only-show-errors \
  --output none
echo "  ✓ Web app updated"

echo ""
echo "▸ Updating worker Container App image..."
az containerapp update \
  --resource-group "$RG_NAME" \
  --name "$WORKER_APP_NAME" \
  --image "${ACR_LOGIN_SERVER}/${WORKER_APP_NAME}:latest" \
  --only-show-errors \
  --output none
echo "  ✓ Worker app updated"

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════════"
echo " Deployment complete!"
echo "═══════════════════════════════════════════════════════════"
echo " Resource Group  : $RG_NAME"
echo " Web App URL     : $WEB_APP_URL"
echo " ACR             : $ACR_LOGIN_SERVER"
echo " PostgreSQL      : $(echo "$DEPLOY_OUTPUT" | jq -r '.POSTGRES_SERVER_FQDN.value')"
echo " Service Bus     : $(echo "$DEPLOY_OUTPUT" | jq -r '.SERVICE_BUS_NAMESPACE.value')"
echo " Key Vault       : $(echo "$DEPLOY_OUTPUT" | jq -r '.KEY_VAULT_URI.value')"
echo "═══════════════════════════════════════════════════════════"

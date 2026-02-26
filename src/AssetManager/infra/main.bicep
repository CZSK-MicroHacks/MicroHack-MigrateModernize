// AssetManager Infrastructure – Main Deployment
// Deploys all Azure resources for the web + worker Container Apps architecture
// with PostgreSQL, Service Bus, Storage, ACR, Key Vault, and managed identity auth.
targetScope = 'subscription'

// ── Parameters ──────────────────────────────────────────────────────────────────

@description('Name of the environment (used as prefix for all resources)')
param environmentName string

@description('Azure region for all resources')
param location string

@description('Tags to apply to all resources')
param tags object = {}

@secure()
@description('PostgreSQL administrator password')
param postgresAdminPassword string

@description('Name of the blob container for images')
param storageContainerName string = 'images'

@description('Name of the Service Bus queue')
param serviceBusQueueName string = 'image-processing'

@description('PostgreSQL database name')
param postgresDatabaseName string = 'assets_manager'

// ── Variables ───────────────────────────────────────────────────────────────────

var resourceSuffix = take(uniqueString(subscription().id, environmentName, location), 6)
var resourceGroupName = 'rg-${environmentName}-${resourceSuffix}'
var allTags = union(tags, { 'azd-env-name': environmentName })

// ── Resource Group ──────────────────────────────────────────────────────────────

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: allTags
}

// ── Managed Identity ────────────────────────────────────────────────────────────

module identity 'modules/managed-identity.bicep' = {
  name: 'managed-identity'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
  }
}

// ── Log Analytics & App Insights ────────────────────────────────────────────────

module logAnalytics 'modules/log-analytics.bicep' = {
  name: 'log-analytics'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
  }
}

// ── Container Registry (with AcrPull role for managed identity) ─────────────────

module acr 'modules/container-registry.bicep' = {
  name: 'container-registry'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
    identityPrincipalId: identity.outputs.principalId
  }
}

// ── Storage Account ─────────────────────────────────────────────────────────────

module storage 'modules/storage.bicep' = {
  name: 'storage'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
    containerName: storageContainerName
    identityPrincipalId: identity.outputs.principalId
  }
}

// ── Service Bus ─────────────────────────────────────────────────────────────────

module serviceBus 'modules/service-bus.bicep' = {
  name: 'service-bus'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
    queueName: serviceBusQueueName
    identityPrincipalId: identity.outputs.principalId
  }
}

// ── PostgreSQL ──────────────────────────────────────────────────────────────────

module postgresql 'modules/postgresql.bicep' = {
  name: 'postgresql'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
    databaseName: postgresDatabaseName
    adminPassword: postgresAdminPassword
    identityPrincipalId: identity.outputs.principalId
    identityName: identity.outputs.name
  }
}

// ── Key Vault ───────────────────────────────────────────────────────────────────

module keyVault 'modules/key-vault.bicep' = {
  name: 'key-vault'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
    identityPrincipalId: identity.outputs.principalId
  }
}

// ── Container Apps Environment ──────────────────────────────────────────────────

module containerAppsEnv 'modules/container-apps-env.bicep' = {
  name: 'container-apps-env'
  scope: rg
  params: {
    name: environmentName
    location: location
    tags: allTags
    logAnalyticsCustomerId: logAnalytics.outputs.customerId
    logAnalyticsSharedKey: logAnalytics.outputs.sharedKey
  }
}

// ── Shared environment variables for both apps ──────────────────────────────────

var sharedEnvVars = [
  { name: 'AZURE_CLIENT_ID', value: identity.outputs.clientId }
  { name: 'AZURE_STORAGE_BLOB_ENDPOINT', value: storage.outputs.blobEndpoint }
  { name: 'AZURE_STORAGE_CONTAINER_NAME', value: storage.outputs.containerName }
  { name: 'AZURE_KEYVAULT_URI', value: keyVault.outputs.uri }
  { name: 'SERVICE_BUS_NAMESPACE', value: serviceBus.outputs.namespaceName }
  { name: 'SERVICE_BUS_QUEUE_NAME', value: serviceBusQueueName }
  { name: 'SPRING_DATASOURCE_URL', value: postgresql.outputs.jdbcUrl }
  { name: 'SPRING_DATASOURCE_USERNAME', value: identity.outputs.name }
]

// ── Web Container App ───────────────────────────────────────────────────────────
// Starts with a placeholder image; deploy.sh updates it after building the real image.

module webApp 'modules/container-app.bicep' = {
  name: 'web-app'
  scope: rg
  dependsOn: [acr]
  params: {
    name: '${environmentName}-web'
    location: location
    tags: allTags
    serviceName: 'web'
    environmentId: containerAppsEnv.outputs.id
    identityId: identity.outputs.id
    registryServer: acr.outputs.loginServer
    targetPort: 8080
    externalIngress: true
    minReplicas: 1
    maxReplicas: 3
    cpu: '0.5'
    memory: '1Gi'
    envVars: sharedEnvVars
  }
}

// ── Worker Container App ────────────────────────────────────────────────────────
// Background processor – no ingress needed.

module workerApp 'modules/container-app.bicep' = {
  name: 'worker-app'
  scope: rg
  dependsOn: [acr]
  params: {
    name: '${environmentName}-worker'
    location: location
    tags: allTags
    serviceName: 'worker'
    environmentId: containerAppsEnv.outputs.id
    identityId: identity.outputs.id
    registryServer: acr.outputs.loginServer
    externalIngress: false
    minReplicas: 1
    maxReplicas: 3
    cpu: '0.5'
    memory: '1Gi'
    envVars: sharedEnvVars
  }
}

// ── Outputs ─────────────────────────────────────────────────────────────────────

output RESOURCE_GROUP_NAME string = rg.name
output WEB_APP_URL string = webApp.outputs.fqdn != '' ? 'https://${webApp.outputs.fqdn}' : ''
output WEB_APP_NAME string = webApp.outputs.name
output WORKER_APP_NAME string = workerApp.outputs.name
output ACR_LOGIN_SERVER string = acr.outputs.loginServer
output ACR_NAME string = acr.outputs.name
output STORAGE_ACCOUNT_NAME string = storage.outputs.accountName
output SERVICE_BUS_NAMESPACE string = serviceBus.outputs.namespaceName
output POSTGRES_SERVER_FQDN string = postgresql.outputs.serverFqdn
output KEY_VAULT_URI string = keyVault.outputs.uri
output MANAGED_IDENTITY_CLIENT_ID string = identity.outputs.clientId

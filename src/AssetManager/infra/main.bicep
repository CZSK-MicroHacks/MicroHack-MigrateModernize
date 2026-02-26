// AssetManager Infrastructure - Main orchestrator
// Deploys all Azure resources for the AssetManager application
targetScope = 'subscription'

@description('Azure region for all resources')
param location string

@description('Resource name prefix')
param prefix string

@description('Blob container name for image storage')
param blobContainerName string = 'images'

@description('Service Bus queue name')
param queueName string = 'image-processing'

@description('PostgreSQL database name')
param databaseName string = 'assetmanager'

@description('Web container image name (without registry)')
param webImageName string = 'assetmgr-web:latest'

@description('Worker container image name (without registry)')
param workerImageName string = 'assetmgr-worker:latest'

param tags object = {
  project: 'AssetManager'
  environment: 'test'
}

var resourceGroupName = '${prefix}-rg'
var uniqueSuffix = uniqueString(subscription().id, prefix)
var shortSuffix = substring(uniqueSuffix, 0, 5)

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// User-Assigned Managed Identity
module identity 'modules/identity.bicep' = {
  scope: rg
  name: 'identity'
  params: {
    location: location
    identityName: '${prefix}-id'
    tags: tags
  }
}

// Virtual Network
module network 'modules/network.bicep' = {
  scope: rg
  name: 'network'
  params: {
    location: location
    vnetName: '${prefix}-vnet'
    tags: tags
  }
}

// Container Registry
module acr 'modules/acr.bicep' = {
  scope: rg
  name: 'acr'
  params: {
    location: location
    acrName: '${prefix}${shortSuffix}acr'
    principalId: identity.outputs.identityPrincipalId
    tags: tags
  }
}

// Storage Account
module storage 'modules/storage.bicep' = {
  scope: rg
  name: 'storage'
  params: {
    location: location
    storageAccountName: '${prefix}${shortSuffix}st'
    containerName: blobContainerName
    principalId: identity.outputs.identityPrincipalId
    acaSubnetId: network.outputs.acaSubnetId
    tags: tags
  }
}

// Service Bus
module serviceBus 'modules/servicebus.bicep' = {
  scope: rg
  name: 'servicebus'
  params: {
    location: location
    serviceBusName: '${prefix}${shortSuffix}bus'
    queueName: queueName
    principalId: identity.outputs.identityPrincipalId
    acaSubnetId: network.outputs.acaSubnetId
    tags: tags
  }
}

// PostgreSQL
module postgresql 'modules/postgresql.bicep' = {
  scope: rg
  name: 'postgresql'
  params: {
    location: location
    serverName: '${prefix}-${shortSuffix}-pg'
    databaseName: databaseName
    identityName: identity.outputs.identityName
    principalId: identity.outputs.identityPrincipalId
    postgresSubnetId: network.outputs.postgresSubnetId
    tags: tags
  }
}

// Container Apps Environment
module acaEnv 'modules/container-apps-env.bicep' = {
  scope: rg
  name: 'aca-env'
  params: {
    location: location
    envName: '${prefix}-env'
    acaSubnetId: network.outputs.acaSubnetId
    tags: tags
  }
}

// Web Container App
module webApp 'modules/container-app-web.bicep' = {
  scope: rg
  name: 'web-app'
  params: {
    location: location
    appName: '${prefix}-web'
    envId: acaEnv.outputs.envId
    identityId: identity.outputs.identityId
    identityClientId: identity.outputs.identityClientId
    identityName: identity.outputs.identityName
    acrLoginServer: acr.outputs.acrLoginServer
    imageName: webImageName
    blobEndpoint: storage.outputs.blobEndpoint
    containerName: storage.outputs.containerName
    serviceBusNamespace: serviceBus.outputs.serviceBusNamespace
    queueName: serviceBus.outputs.queueName
    postgresServerFqdn: postgresql.outputs.serverFqdn
    postgresDatabaseName: postgresql.outputs.databaseName
    tags: tags
  }
}

// Worker Container App
module workerApp 'modules/container-app-worker.bicep' = {
  scope: rg
  name: 'worker-app'
  params: {
    location: location
    appName: '${prefix}-worker'
    envId: acaEnv.outputs.envId
    identityId: identity.outputs.identityId
    identityClientId: identity.outputs.identityClientId
    identityName: identity.outputs.identityName
    acrLoginServer: acr.outputs.acrLoginServer
    imageName: workerImageName
    blobEndpoint: storage.outputs.blobEndpoint
    containerName: storage.outputs.containerName
    serviceBusNamespace: serviceBus.outputs.serviceBusNamespace
    queueName: serviceBus.outputs.queueName
    postgresServerFqdn: postgresql.outputs.serverFqdn
    postgresDatabaseName: postgresql.outputs.databaseName
    tags: tags
  }
}

// Outputs
output resourceGroupName string = rg.name
output acrLoginServer string = acr.outputs.acrLoginServer
output webAppFqdn string = webApp.outputs.webAppFqdn
output identityClientId string = identity.outputs.identityClientId
output serviceBusNamespace string = serviceBus.outputs.serviceBusNamespace
output storageEndpoint string = storage.outputs.blobEndpoint
output postgresServerFqdn string = postgresql.outputs.serverFqdn

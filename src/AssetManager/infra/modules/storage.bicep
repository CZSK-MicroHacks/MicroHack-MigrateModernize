targetScope = 'resourceGroup'

@description('Base name for the storage account')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Name of the blob container to create')
param containerName string = 'images'

@description('Principal ID of the managed identity to grant Storage Blob Data Contributor')
param identityPrincipalId string

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
// Storage account names: lowercase alphanumeric, 3-24 chars
var storageAccountName = take(replace('${name}st${resourceSuffix}', '-', ''), 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Enabled'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: blobService
  name: containerName
  properties: {
    publicAccess: 'None'
  }
}

// Storage Blob Data Contributor role
resource storageBlobRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, identityPrincipalId, 'storage-blob-contributor')
  scope: storageAccount
  properties: {
    principalId: identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  }
}

output accountName string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
output containerName string = containerName

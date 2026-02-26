targetScope = 'resourceGroup'

@description('Base name for the managed identity')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
var identityName = '${name}-id-${resourceSuffix}'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
  tags: tags
}

output id string = managedIdentity.id
output principalId string = managedIdentity.properties.principalId
output clientId string = managedIdentity.properties.clientId
output name string = managedIdentity.name

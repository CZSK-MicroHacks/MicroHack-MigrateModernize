targetScope = 'resourceGroup'

@description('Base name for the registry')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Principal ID of the managed identity to grant AcrPull')
param identityPrincipalId string

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
// ACR names must be alphanumeric only
var registryName = replace('${name}acr${resourceSuffix}', '-', '')

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: registryName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
    anonymousPullEnabled: false
  }
}

// AcrPull role assignment – must be defined BEFORE any container apps
resource acrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.id, identityPrincipalId, 'acrpull')
  scope: containerRegistry
  properties: {
    principalId: identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  }
}

output loginServer string = containerRegistry.properties.loginServer
output name string = containerRegistry.name
output id string = containerRegistry.id

targetScope = 'resourceGroup'

@description('Base name for the Key Vault')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Principal ID of the managed identity to grant Key Vault Secrets User')
param identityPrincipalId string

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
// Key Vault names: 3-24 chars, alphanumeric and hyphens
var vaultName = take('${name}-kv-${resourceSuffix}', 24)

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: true
  }
}

// Key Vault Secrets User role
resource kvSecretsRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, identityPrincipalId, 'kv-secrets-user')
  scope: keyVault
  properties: {
    principalId: identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
  }
}

output uri string = keyVault.properties.vaultUri
output name string = keyVault.name

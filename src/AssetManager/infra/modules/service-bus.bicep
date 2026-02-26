targetScope = 'resourceGroup'

@description('Base name for the Service Bus namespace')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Name of the queue to create')
param queueName string = 'image-processing'

@description('Principal ID of the managed identity to grant Service Bus Data Owner')
param identityPrincipalId string

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
var namespaceName = '${name}-sb-${resourceSuffix}'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: namespaceName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: serviceBusNamespace
  name: queueName
  properties: {
    maxDeliveryCount: 10
    lockDuration: 'PT1M'
    deadLetteringOnMessageExpiration: true
  }
}

// Azure Service Bus Data Owner role
resource serviceBusRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(serviceBusNamespace.id, identityPrincipalId, 'servicebus-data-owner')
  scope: serviceBusNamespace
  properties: {
    principalId: identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '090c5cfd-751d-490a-894a-3ce6f1109419')
  }
}

output namespaceName string = serviceBusNamespace.name
output namespaceFqdn string = '${serviceBusNamespace.name}.servicebus.windows.net'
output queueName string = queueName

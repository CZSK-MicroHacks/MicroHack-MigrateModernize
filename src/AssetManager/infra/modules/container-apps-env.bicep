targetScope = 'resourceGroup'

@description('Base name for the Container Apps environment')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Log Analytics workspace customer ID')
param logAnalyticsCustomerId string

@description('Log Analytics workspace shared key')
@secure()
param logAnalyticsSharedKey string

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
var envName = '${name}-env-${resourceSuffix}'

resource containerAppsEnv 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: envName
  location: location
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsCustomerId
        sharedKey: logAnalyticsSharedKey
      }
    }
  }
}

output id string = containerAppsEnv.id
output name string = containerAppsEnv.name

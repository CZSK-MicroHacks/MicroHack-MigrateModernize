targetScope = 'resourceGroup'

@description('Base name for the resources')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
var workspaceName = '${name}-log-${resourceSuffix}'
var appInsightsName = '${name}-ai-${resourceSuffix}'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  tags: tags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

output workspaceId string = logAnalytics.id
output workspaceName string = logAnalytics.name
output customerId string = logAnalytics.properties.customerId
output appInsightsConnectionString string = appInsights.properties.ConnectionString
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey

// Expose the key via a function so the Container Apps Environment can reference it
output sharedKey string = logAnalytics.listKeys().primarySharedKey

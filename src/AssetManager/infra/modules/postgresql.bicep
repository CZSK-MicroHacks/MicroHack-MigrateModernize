targetScope = 'resourceGroup'

@description('Base name for the PostgreSQL server')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Name of the database to create')
param databaseName string = 'assets_manager'

@description('PostgreSQL administrator login')
param adminLogin string = 'pgadmin'

@secure()
@description('PostgreSQL administrator password')
param adminPassword string

@description('Principal ID of the managed identity for Entra admin')
param identityPrincipalId string

@description('Name of the managed identity for Entra admin')
param identityName string

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
var serverName = '${name}-pg-${resourceSuffix}'

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' = {
  name: serverName
  location: location
  tags: tags
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: '16'
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    storage: {
      storageSizeGB: 32
    }
    authConfig: {
      activeDirectoryAuth: 'Enabled'
      passwordAuth: 'Enabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
  }
}

resource database 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2024-08-01' = {
  parent: postgresServer
  name: databaseName
  properties: {
    charset: 'UTF8'
    collation: 'en_US.utf8'
  }
}

// Allow Azure services to connect
resource firewallRule 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2024-08-01' = {
  parent: postgresServer
  name: 'AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Set managed identity as Entra AD administrator
resource entraAdmin 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2024-08-01' = {
  parent: postgresServer
  name: identityPrincipalId
  dependsOn: [database, firewallRule]
  properties: {
    principalType: 'ServicePrincipal'
    principalName: identityName
    tenantId: subscription().tenantId
  }
}

output serverFqdn string = postgresServer.properties.fullyQualifiedDomainName
output serverName string = postgresServer.name
output databaseName string = databaseName
output jdbcUrl string = 'jdbc:postgresql://${postgresServer.properties.fullyQualifiedDomainName}:5432/${databaseName}?sslmode=require&authenticationPluginClassName=com.azure.identity.extensions.jdbc.postgresql.AzurePostgresqlAuthenticationPlugin'

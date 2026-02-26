// Worker Container App with no ingress
param location string
param appName string
param envId string
param identityId string
param identityClientId string
param acrLoginServer string
param imageName string
param blobEndpoint string
param containerName string
param serviceBusNamespace string
param queueName string
param postgresServerFqdn string
param postgresDatabaseName string
param identityName string
param tags object = {}

resource workerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityId}': {}
    }
  }
  properties: {
    managedEnvironmentId: envId
    configuration: {
      activeRevisionsMode: 'Single'
      registries: [
        {
          server: acrLoginServer
          identity: identityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'worker'
          image: '${acrLoginServer}/${imageName}'
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          env: [
            { name: 'AZURE_CLIENT_ID', value: identityClientId }
            { name: 'AZURE_STORAGE_BLOB_ENDPOINT', value: blobEndpoint }
            { name: 'AZURE_STORAGE_CONTAINER_NAME', value: containerName }
            { name: 'SERVICE_BUS_NAMESPACE', value: serviceBusNamespace }
            { name: 'SERVICE_BUS_QUEUE_NAME', value: queueName }
            { name: 'SPRING_DATASOURCE_URL', value: 'jdbc:postgresql://${postgresServerFqdn}:5432/${postgresDatabaseName}?sslmode=require&authenticationPluginClassName=com.azure.identity.extensions.jdbc.postgresql.AzurePostgresqlAuthenticationPlugin' }
            { name: 'SPRING_DATASOURCE_USERNAME', value: identityName }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 3
      }
    }
  }
}

output workerAppName string = workerApp.name

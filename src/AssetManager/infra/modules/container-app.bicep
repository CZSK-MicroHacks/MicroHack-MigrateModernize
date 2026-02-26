targetScope = 'resourceGroup'

@description('Name of the container app')
param name string

@description('Azure region for deployment')
param location string = resourceGroup().location

@description('Tags to apply to all resources')
param tags object = {}

@description('Container Apps Environment ID')
param environmentId string

@description('Container image to deploy')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('User-assigned managed identity resource ID')
param identityId string

@description('ACR login server')
param registryServer string

@description('Target port for the container')
param targetPort int = 8080

@description('Whether to enable external ingress')
param externalIngress bool = false

@description('Minimum number of replicas')
param minReplicas int = 1

@description('Maximum number of replicas')
param maxReplicas int = 3

@description('Environment variables for the container')
param envVars array = []

@description('CPU cores allocated to the container')
param cpu string = '0.5'

@description('Memory allocated to the container')
param memory string = '1Gi'

@description('Tag to identify this as an azd service')
param serviceName string = ''

var resourceSuffix = take(uniqueString(subscription().id, resourceGroup().name, name), 6)
var appName = '${name}-${resourceSuffix}'
var appTags = serviceName != '' ? union(tags, { 'azd-service-name': serviceName }) : tags

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  tags: appTags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityId}': {}
    }
  }
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      registries: [
        {
          server: registryServer
          identity: identityId
        }
      ]
      ingress: externalIngress ? {
        external: true
        targetPort: targetPort
        transport: 'auto'
        corsPolicy: {
          allowedOrigins: ['*']
          allowedMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
          allowedHeaders: ['*']
          maxAge: 3600
        }
      } : null
    }
    template: {
      containers: [
        {
          name: name
          image: containerImage
          resources: {
            cpu: json(cpu)
            memory: memory
          }
          env: envVars
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

output fqdn string = externalIngress && containerApp.properties.configuration.ingress != null ? containerApp.properties.configuration.ingress.fqdn : ''
output name string = containerApp.name
output id string = containerApp.id

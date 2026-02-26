using 'main.bicep'

param location = 'swedencentral'
param prefix = 'assetmgtest'
param blobContainerName = 'images'
param queueName = 'image-processing'
param databaseName = 'assetmanager'
param webImageName = 'assetmgr-web:latest'
param workerImageName = 'assetmgr-worker:latest'

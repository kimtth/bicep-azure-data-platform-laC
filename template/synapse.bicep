param project string 
param env string
param location string = resourceGroup().location
param prefix string
param administratorUsername string
@secure()
param administratorPassword string
param purviewId string

var synapseName = '${project}-${prefix}-${env}'
var synapseStorageName = '${project}${prefix}${env}'
var mrg = '${project}-${prefix}-${env}-mg'

@description('Enable/Disable Transparent Data Encryption')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'
var synapseStorageUrlformat = 'https://{0}.dfs.${environment().suffixes.storage}' //environment().suffixes.storage equals core.windows.net'
param containerNames array = [
  'raw'
  'curated'
]

@description('https://docs.microsoft.com/en-us/azure/templates/microsoft.datalakestore/accounts?tabs=bicep')
resource datalakegen2 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: synapseStorageName
  location: location 
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS' 
  }
  tags: {
    group: 'workplaceDashboard'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    accessTier: 'Hot'
    isHnsEnabled: true //Data Lake Gen2 upgrade
  } 
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = [for name in containerNames: {
  name: '${datalakegen2.name}/default/${name}'
}]

@description('https://docs.microsoft.com/en-us/azure/templates/microsoft.synapse/workspaces?tabs=bicep')
resource synapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseName
  location: location
  tags: {
    group: 'workplaceDashboard'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: format(synapseStorageUrlformat, datalakegen2.name)
      filesystem: '${datalakegen2.name}fs'
    }
    managedResourceGroupName: mrg
    publicNetworkAccess: publicNetworkAccess
    purviewConfiguration: {
      purviewResourceId: purviewId
    }
    sqlAdministratorLogin: administratorUsername
    sqlAdministratorLoginPassword: administratorPassword
  }
  identity:{
    type:'SystemAssigned' //Workspace cannot be created with only UserAssigned identity. Specify Identity Type to be either 'SystemAssigned' or 'SystemAssigned,UserAssigned'
  }
}

output synapseId string = synapse.id
output synapseName string = synapse.name

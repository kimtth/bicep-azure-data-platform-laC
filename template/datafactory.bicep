param project string 
param env string 
param location string
param prefix string

var datafactoryName = '${project}-${prefix}-${env}'

param purviewId string

@description('https://docs.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory-bicep?tabs=CLI')
resource adf 'Microsoft.DataFactory/factories@2018-06-01'= {
  name: datafactoryName
  location: location
  tags: {
    group: 'workplaceDashboard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties:{
    publicNetworkAccess: 'Enabled' // 'Disabled'
    purviewConfiguration: {
      purviewResourceId: purviewId
    }
  }
}

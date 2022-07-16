param project string 
param env string
param location string = resourceGroup().location
param prefix string

var purviewName = '${project}-${prefix}-${env}'
var mrg = '${project}-${prefix}-${env}-mg'

@description('https://docs.microsoft.com/en-us/azure/templates/microsoft.purview/accounts?tabs=bicep')
resource purview 'Microsoft.Purview/accounts@2021-07-01' = {
  name: purviewName
  location: location
  properties: {
    managedResourceGroupName: mrg
    publicNetworkAccess: 'Enabled'
  }
  tags: {
    group: 'workplaceDashboard'
    //https://docs.microsoft.com/en-us/answers/questions/343157/unable-to-provision-azure-purview-since-release.html
    //Kim: Resolved by Azure Portal > Subscriptions > Resource Providers > Event Hub > Register
  }
  identity: {
    type: 'SystemAssigned'
  }
}

@description('https://www.mangrovedata.co.uk/blog/2021/6/12/passing-azure-bicep-output-parameters-between-modules')
output purviewId string = purview.id

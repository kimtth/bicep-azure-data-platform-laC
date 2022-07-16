var sub = subscription().subscriptionId
param project string 
param env string 
param location string
param prefix string

var databrickName = '${project}-${prefix}-${env}'
var mrg = '${project}-${prefix}-${env}-mg'
var pricingTier = 'standard' // trial | standard | premium
var managedResourceGroupId = '/subscriptions/${sub}/resourceGroups/${mrg}'

@description('https://docs.microsoft.com/en-us/azure/templates/microsoft.databricks/workspaces?tabs=bicep')
resource databricks 'Microsoft.Databricks/workspaces@2021-04-01-preview' = {
   name: databrickName
   location: location
   sku: {
    name: pricingTier
   }
   tags: {
    group: 'workplaceDashboard'
   }
   properties: { 
    managedResourceGroupId: managedResourceGroupId
    publicNetworkAccess: 'Enabled' // 'Disabled'
    parameters: {
      
    }
   }
}

output databricksWorkspaceName string = databrickName
output workspaceUrl string = databricks.properties.workspaceUrl

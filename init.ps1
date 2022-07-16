param($resourceGroup, $location)

az group create --name $resourceGroup --location $location
az deployment group create --resource-group $resourceGroup --template-file .\main.bicep --parameters .\deploy.parameter.json

# Inline parameters
# PS> az deployment group create --resource-group $resourceGroup --template-file .\template\purview.bicep --parameters project='demo' env='dev' prefix='pv' 

# Delete the Resource group
# az group delete --name $resourceGroup

param project string 
param envrionment string 
param location string = resourceGroup().location

param deployDataFactory bool
param deployDatabricks bool
param deploySynapse bool
param deployPurview bool

param administratorUsername string
param administratorPassword string

module purv './template/purview.bicep' = if (deployPurview){
  name: 'purviewDeploy'
  params: {
    project: project
    env: envrionment
    location: location
    prefix: 'puv'
  }
} 

module adf './template/datafactory.bicep' = if (deployDataFactory){
  name: 'dfDeploy'
  params: {
    project: project
    env: envrionment
    location: location
    prefix: 'adf'
    purviewId: purv.outputs.purviewId //Parameters Injection between modules.
  }
}

module dbr './template/databricks.bicep' = if(deployDatabricks) {
  name: 'databricksDeploy'
  params: {
    project: project
    env: envrionment
    location: location
    prefix: 'dbr'
  }
}

module syn './template/synapse.bicep' = if(deploySynapse) {
  name: 'synapseAnalysticDeploy'
  params: {
    project: project
    env: envrionment
    location: location
    prefix: 'syn' 
    administratorUsername: administratorUsername
    administratorPassword: administratorPassword
    purviewId: purv.outputs.purviewId //Parameters Injection between modules.
  }
}

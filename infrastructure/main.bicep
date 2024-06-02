targetScope='subscription'

param location string = 'westeurope'
param acaEnvironmentName string = 'aca-saga'
param acrName string = 'acrsagaskycave'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-saga'
  location: location
}

module orchestrationEventHub 'modules/eventhub.bicep' = {
  name: 'orchestrationEventHub'
  scope: resourceGroup(rg.name)
  params: {
    name: 'orchestration'
    location: location
  }
}

module orchestrationStorage 'modules/storage.bicep' = {
  name: 'orchestrationStorage'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    name: 'orchestration'
  }
}

module choreographyEventHub 'modules/eventhub.bicep' = {
  name: 'choreographyEventHub'
  scope: resourceGroup(rg.name)
  params: {
    name: 'choreography'
    location: location
  }
}

module choreographyStorage 'modules/storage.bicep' = {
  name: 'choreographyStorage'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    name: 'choreography'
  }
}

module identity 'modules/identity.bicep' = {
  name: 'defaultAppIdentity'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    name: 'defaultAppIdentity'
  }
}

module acr 'modules/acr.bicep' = {
  name: 'acr'
  scope: resourceGroup(rg.name)
  params: {
    acrName: acrName
    principalID: identity.outputs.identityPrincipalId
    location: location
  }
}

module redisChoreography 'modules/redis.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'redischoreography'
  params: {
    name: 'redisChoreography'
    location: location
  }
}

module redisOrchestration 'modules/redis.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'redisOrchestration'
  params: {
    name: 'redisOrchestration'
    location: location
  }
}

module acaEnvironment 'modules/acaEnvironment.bicep' = {
  name: acaEnvironmentName
  scope: resourceGroup(rg.name) 
  params: {
    acaEnvironmentName: acaEnvironmentName
    location: location
  }
  dependsOn: [
    acr
    redisChoreography
    redisOrchestration
  ]
}

module appSkyCaveOrchestration 'modules/app.bicep' = {
  name: 'appSkyCaveOrchestration'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-sky-cave-orchestration'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'orchestration/skycave-daemon'
    imageVersion: 'latest'
    redisHostname: redisOrchestration.outputs.redisHostname
    redisKey: redisOrchestration.outputs.redisKey
    targetPort: 7777
    storageConnectionString: orchestrationStorage.outputs.connectionString
    eventhubConnectionString: orchestrationEventHub.outputs.connectionString
    probePath: '/info'
    cpu: '1'
    memory: '2Gi'
  }
}

module appCaveOrchestration 'modules/app.bicep' = {
  name: 'appCaveOrchestration'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-cave-orchestration'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'orchestration/cave-service'
    imageVersion: 'latest'
    redisHostname: redisOrchestration.outputs.redisHostname
    redisKey: redisOrchestration.outputs.redisKey
    targetPort: 8082
    storageConnectionString: orchestrationStorage.outputs.connectionString
    eventhubConnectionString: orchestrationEventHub.outputs.connectionString
    probePath: '/actuator/health'
    cpu: '0.5'
    memory: '1Gi'
  }
}

module appPlayerOrchestration 'modules/app.bicep' = {
  name: 'appPlayerOrchestration'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-player-orchestration'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'orchestration/player-service'
    imageVersion: 'latest'
    redisHostname: redisOrchestration.outputs.redisHostname
    redisKey: redisOrchestration.outputs.redisKey
    targetPort: 8081
    storageConnectionString: orchestrationStorage.outputs.connectionString
    eventhubConnectionString: orchestrationEventHub.outputs.connectionString
    probePath: '/actuator/health'
    cpu: '0.5'
    memory: '1Gi'
  }
}

module appMessageOrchestration 'modules/app.bicep' = {
  name: 'appMessageOrchestration'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-message-orchestration'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'orchestration/message-service'
    imageVersion: 'latest'
    redisHostname: redisOrchestration.outputs.redisHostname
    redisKey: redisOrchestration.outputs.redisKey
    targetPort: 8080
    storageConnectionString: orchestrationStorage.outputs.connectionString
    eventhubConnectionString: orchestrationEventHub.outputs.connectionString
    probePath: '/actuator/health'
    cpu: '0.5'
    memory: '1Gi'
  }
}

module appSkyCaveChoreography 'modules/app.bicep' = {
  name: 'appSkyCaveChoreography'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-sky-cave-choreography'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'choreography/sky-cave-service'
    imageVersion: 'latest'
    redisHostname: redisChoreography.outputs.redisHostname
    redisKey: redisChoreography.outputs.redisKey
    targetPort: 7777
    storageConnectionString: choreographyStorage.outputs.connectionString
    eventhubConnectionString: choreographyEventHub.outputs.connectionString
    probePath: '/info'
    cpu: '1'
    memory: '2Gi'
  }
}

module appCaveChoreography 'modules/app.bicep' = {
  name: 'appCaveChoreography'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-cave-choreography'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'choreography/cave-service'
    imageVersion: 'latest'
    redisHostname: redisChoreography.outputs.redisHostname
    redisKey: redisChoreography.outputs.redisKey
    targetPort: 8082
    storageConnectionString: choreographyStorage.outputs.connectionString
    eventhubConnectionString: choreographyEventHub.outputs.connectionString
    probePath: '/actuator/health'
    cpu: '0.5'
    memory: '1Gi'
  }
}

module appPlayerChoreography 'modules/app.bicep' = {
  name: 'appPlayerChoreography'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-player-choreography'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'choreography/player-service'
    imageVersion: 'latest'
    redisHostname: redisChoreography.outputs.redisHostname
    redisKey: redisChoreography.outputs.redisKey
    targetPort: 8081
    storageConnectionString: choreographyStorage.outputs.connectionString
    eventhubConnectionString: choreographyEventHub.outputs.connectionString
    probePath: '/actuator/health'
    cpu: '0.5'
    memory: '1Gi'
  }
}

module appMessageChoreography 'modules/app.bicep' = {
  name: 'appMessageChoreography'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    acrName: acrName
    appInsightsConnectionString: acaEnvironment.outputs.InstrumentationKey
    appName: 'app-message-choreography'
    environmentId: acaEnvironment.outputs.environmentId
    identityResourceId: identity.outputs.identityId
    imageName: 'choreography/message-service'
    imageVersion: 'latest'
    redisHostname: redisChoreography.outputs.redisHostname
    redisKey: redisChoreography.outputs.redisKey
    targetPort: 8080
    storageConnectionString: choreographyStorage.outputs.connectionString
    eventhubConnectionString: choreographyEventHub.outputs.connectionString
    probePath: '/actuator/health'
    cpu: '0.5'
    memory: '1Gi'
  }
}







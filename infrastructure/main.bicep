targetScope='subscription'

param location string = 'westeurope'

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



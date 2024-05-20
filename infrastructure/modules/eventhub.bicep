param name string
param location string
param eventHubSku string = 'Standard'

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: 'evh-${name}'
  location: location
  sku: {
    name: eventHubSku
    tier: eventHubSku
    capacity: 1
  }
  properties: {
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
  }
}

resource auth 'Microsoft.EventHub/namespaces/authorizationRules@2023-01-01-preview' = {
  name: 'RootManageSharedAccessKey'
  parent: eventHubNamespace
  properties: {
    rights: ['Listen', 'Manage', 'Send']
  }
}

resource eventHubCave 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  parent: eventHubNamespace
  name: 'cave'
  properties: {
    retentionDescription: {
      cleanupPolicy: 'Delete'
      retentionTimeInHours: 24
    }
    messageRetentionInDays: 1
    partitionCount: 1
  }
  
  resource consumerGroupCave 'consumergroups' = {
    name: 'cave'
  }

  resource consumerGroupPlayer 'consumergroups' = {
    name: 'player'
  }

  resource consumerGroupMessages 'consumergroups' = {
    name: 'messages'
  }

  resource consumerGroupDaemon 'consumergroups' = {
    name: 'daemon'
  }
}

resource eventHubPlayer 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  parent: eventHubNamespace
  name: 'player'
  properties: {
    retentionDescription: {
      cleanupPolicy: 'Delete'
      retentionTimeInHours: 24
    }
    messageRetentionInDays: 1
    partitionCount: 1
  }
  
  resource consumerGroupCave 'consumergroups' = {
    name: 'cave'
  }

  resource consumerGroupPlayer 'consumergroups' = {
    name: 'player'
  }

  resource consumerGroupMessages 'consumergroups' = {
    name: 'messages'
  }

  resource consumerGroupDaemon 'consumergroups' = {
    name: 'daemon'
  }
}

resource eventHubMessages 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  parent: eventHubNamespace
  name: 'messages'
  properties: {
    retentionDescription: {
      cleanupPolicy: 'Delete'
      retentionTimeInHours: 24
    }
    messageRetentionInDays: 1
    partitionCount: 1
  }
  
  resource consumerGroupCave 'consumergroups' = {
    name: 'cave'
  }

  resource consumerGroupPlayer 'consumergroups' = {
    name: 'player'
  }

  resource consumerGroupMessages 'consumergroups' = {
    name: 'messages'
  }

  resource consumerGroupDaemon 'consumergroups' = {
    name: 'daemon'
  }
}

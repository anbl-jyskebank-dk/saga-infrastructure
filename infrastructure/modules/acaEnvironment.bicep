param location string
param acaEnvironmentName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'workspace-${acaEnvironmentName}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    features: {
      searchVersion: 1
    }
    retentionInDays: 31
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'app-Insights-${acaEnvironmentName}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource environment 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: acaEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    daprAIInstrumentationKey: appInsights.properties.InstrumentationKey
    zoneRedundant: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

output InstrumentationKey string = appInsights.properties.ConnectionString
output environmentId string = environment.id

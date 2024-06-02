param appName string
param location string
param identityResourceId string
param environmentId string
param appInsightsConnectionString string
param redisHostname string
param acrName string
param imageName string
param imageVersion string
@secure()
param redisKey string
param targetPort int
@secure()
param eventhubConnectionString string
@secure()
param storageConnectionString string
param probePath string
param cpu string
param memory string

resource defaultApp 'Microsoft.App/containerApps@2022-11-01-preview' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityResourceId}':{}
    }
  }
  properties: {
    managedEnvironmentId: environmentId
    template: {
      containers: [
        {
          env: [
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: appInsightsConnectionString
            }
            {
              name: 'REDIS_KEY'
              secretRef: 'redis-key'
            }
            {
              name: 'REDIS_HOSTNAME'
              value: redisHostname
            }
            {
              name: 'REDIS_PORT'
              value: '6380'
            }
            {
              name: 'EVENTHUB_CONNECTION_STRING'
              value: eventhubConnectionString
            }
            {
              name: 'STORAGE_ACCOUNT_CONNECTION_STRING'
              value: storageConnectionString
            }
            {
              name: 'ENVIRONMENT'
              value: 'production'
            }
          ]
          probes: [
            {
              type: 'Liveness'
              httpGet: {
                port: targetPort
                path: probePath
              }
              periodSeconds: 60
            }
            {
              type: 'Readiness'
              httpGet: {
                port: targetPort
                path: probePath
              }
              periodSeconds: 60
            }
            {
              type: 'Startup'
              httpGet: {
                port: targetPort
                path: probePath
              }
              periodSeconds: 60
            }
          ]
          image: '${acrName}.azurecr.io/${imageName}:${imageVersion}'
          name: appName
          resources: {
            cpu: cpu
            memory: memory
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
    configuration: {
      secrets: [
        {
          name: 'redis-key'
          value: redisKey
        }
      ]
      registries: [
        {
          identity: identityResourceId
          server: '${acrName}.azurecr.io'
        }
      ]
      activeRevisionsMode: 'Single'
      ingress: {
        targetPort: targetPort
        allowInsecure: true
        external: true
        transport: 'http'
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }
  }
}

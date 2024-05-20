param name string
param location string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: 'st${name}skycave'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        blob: {
          keyType: 'Account'
          enabled: true 
        }
        file: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
  resource blob 'blobServices' = {
    name: 'default'
    properties: {
      cors: {
        corsRules: []
      }
      deleteRetentionPolicy: {
        allowPermanentDelete: true
        enabled: true
        days: 1
      }
    }

    resource containerMessages 'containers' = {
      name: 'message-checkpoint'
      properties: {
        immutableStorageWithVersioning: {
          enabled: false
        }
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride: false
        publicAccess: 'None'
      }
    }

    resource containerPlayer 'containers' = {
      name: 'player-checkpoint'
      properties: {
        immutableStorageWithVersioning: {
          enabled: false
        }
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride: false
        publicAccess: 'None'
      }
    }

    resource containerCave 'containers' = {
      name: 'cave-checkpoint'
      properties: {
        immutableStorageWithVersioning: {
          enabled: false
        }
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride: false
        publicAccess: 'None'
      }
    }

    resource containerDaemon 'containers' = {
      name: 'daemon-checkpoint'
      properties: {
        immutableStorageWithVersioning: {
          enabled: false
        }
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride: false
        publicAccess: 'None'
      }
    }
  }
}

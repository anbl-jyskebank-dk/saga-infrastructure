param location string
param name string

resource redis 'Microsoft.Cache/redis@2023-04-01' = {
  name: 'redis-${name}'
  location: location
  properties: {
    redisVersion: '6.0'
    sku: {
      name: 'Standard'
      capacity: 0
      family: 'C'
    }
    enableNonSslPort: false
    publicNetworkAccess: 'Enabled'
    redisConfiguration: {
      'maxmemory-reserved': '30'
      'maxfragmentationmemory-reserved': '30'
      'maxmemory-delta': '30'
    }
  }
}


output redisName string = redis.name
output redisKey string = listKeys(redis.id, '2022-06-01').primaryKey
output redisHostname string = redis.properties.hostName

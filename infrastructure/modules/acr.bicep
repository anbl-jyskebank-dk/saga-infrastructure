param principalID string
param roleDefinitionID string = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string

@description('Provide a location for the registry.')
param location string

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
}

@description('Output the login server property for later use')
output loginServer string = acr.properties.loginServer

resource acrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: acr
  name: guid(acrName, principalID, roleDefinitionID)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionID)
    principalId: principalID
    principalType: 'ServicePrincipal'
  }
}

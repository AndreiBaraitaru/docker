@description('Required. Name of the Key Vault.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable vault for deployment.')
param enableVaultForDeployment bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource.')
param roleAssignments array = [
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // Replace with the correct Object ID
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]

var builtInRoleNames = {
  'Key Vault Secrets User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForDeployment: enableVaultForDeployment
    enabledForTemplateDeployment: true
    accessPolicies: [] // RBAC-based permissions
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (assignment, index) in roleAssignments: {
  name: guid(keyVault.id, assignment.principalId, assignment.roleDefinitionIdOrName)
  scope: keyVault
  properties: {
    roleDefinitionId: builtInRoleNames[assignment.roleDefinitionIdOrName] ?? assignment.roleDefinitionIdOrName
    principalId: assignment.principalId
    principalType: assignment.principalType
  }
}]

output name string = keyVault.name
output id string = keyVault.id
output uri string = keyVault.properties.vaultUri

@description('The name of the Key Vault')
param name string = 'AndreiAppRegistry-kv'

@description('The location where the Key Vault will be deployed')
param location string = resourceGroup().location

@description('Array of access policies for the Key Vault')
param accessPolicies array = []

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: accessPolicies
  }
}

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri

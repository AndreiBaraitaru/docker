param name string
param location string
param acrAdminUserEnabled bool

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

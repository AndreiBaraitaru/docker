param name string = 'andreiAppRegistry'
param location string = resourceGroup().location
param acrAdminUserEnabled bool = true

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-08-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

output registryLoginServer string = containerRegistry.properties.loginServer
output adminUsername string = listCredentials(containerRegistry.id, '2019-05-01').username
output adminPassword string = listCredentials(containerRegistry.id, '2019-05-01').passwords[0].value

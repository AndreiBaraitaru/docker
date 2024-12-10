param name string = 'andreiAppServicePlan'
param location string = resourceGroup().location
param sku object = {
  tier: 'Basic'
  name: 'B1'
  capacity: 1
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: name
  location: location
  sku: sku
  kind: 'linux'
  reserved: true
}

output serverFarmId string = appServicePlan.id

param name string
param location string
param sku object
param kind string
param reserved bool

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: sku
  properties: {
    kind: kind
    reserved: reserved
  }
}

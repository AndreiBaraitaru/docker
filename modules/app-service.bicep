param name string = 'andreiAppService'
param location string = resourceGroup().location
param serverFarmResourceId string
param siteConfig object = {
  linuxFxVersion: 'DOCKER|andreiAppRegistry.azurecr.io/python-flask-app:latest'
  appCommandLine: ''
  appSettings: [
    {
      name: 'DOCKER_REGISTRY_SERVER_URL'
      value: 'https://andreiAppRegistry.azurecr.io'
    }
    {
      name: 'DOCKER_REGISTRY_SERVER_USERNAME'
      value: '<acr-username>'
    }
    {
      name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
      value: '<acr-password>'
    }
  ]
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: name
  location: location
  kind: 'app'
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

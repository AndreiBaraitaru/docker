module containerRegistry './modules/container-registry.bicep' = {
  name: 'andreiAppRegistryModule'
  params: {
    name: 'andreiAppRegistry'
    location: resourceGroup().location
    acrAdminUserEnabled: true
  }
}

module appServicePlan './modules/app-service-plan.bicep' = {
  name: 'andreiAppServicePlanModule'
  params: {
    name: 'andreiAppServicePlan'
    location: resourceGroup().location
    sku: {
      tier: 'Basic'
      name: 'B1'
      capacity: 1
    }
  }
}

module appService './modules/app-service.bicep' = {
  name: 'andreiAppServiceModule'
  params: {
    name: 'andreiAppService'
    location: resourceGroup().location
    serverFarmResourceId: appServicePlan.outputs.serverFarmId
    siteConfig: {
      linuxFxVersion: 'DOCKER|andreiAppRegistry.azurecr.io/python-flask-app:latest'
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://andreiAppRegistry.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: containerRegistry.outputs.adminUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: containerRegistry.outputs.adminPassword
        }
      ]
    }
  }
}

module keyVault './modules/key-vault.bicep' = {
  name: 'andreiKeyVaultModule'
  params: {
    name: 'AndreiAppRegistry-kv'
    location: resourceGroup().location
  }
}

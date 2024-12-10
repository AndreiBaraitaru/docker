param name string
param location string
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param dockerRegistryServerUrl string
param dockerRegistryServerUsername string
param dockerRegistryServerPassword string
param appServicePlanName string

module acr './modules/container-registry.bicep' = {
  name: 'deployAcr'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: true
  }
}

module appServicePlan './modules/app-service-plan.bicep' = {
  name: 'deployAppServicePlan'
  params: {
    name: appServicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

module webApp './modules/app-service.bicep' = {
  name: 'deployWebApp'
  params: {
    name: name
    location: location
    kind: 'app'
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: dockerRegistryServerUrl
      DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
    }
  }
}

param location string = 'eastus'
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param appServicePlanName string
param appServiceName string
param keyVaultName string
param dockerRegistryServerUrl string
param dockerRegistryServerUsername string
param dockerRegistryServerPassword string

module containerRegistry './modules/container-registry.bicep' = {
  name: 'deployContainerRegistry'
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
  }
}

module webApp './modules/app-service.bicep' = {
  name: 'deployWebApp'
  params: {
    name: appServiceName
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.appServicePlanId
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

module keyVault './modules/key-vault.bicep' = {
  name: 'deployKeyVault'
  params: {
    name: keyVaultName
    location: location
  }
}

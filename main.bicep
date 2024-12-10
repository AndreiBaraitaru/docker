@description('The name of the Azure Container Registry')
param name string

@description('The location for the deployment')
param location string

@description('Enable admin user for the Azure Container Registry')
param acrAdminUserEnabled bool

@description('The name of the App Service')
param appServiceName string

@description('The name of the container image')
param containerRegistryImageName string

@description('The version/tag of the container image')
param containerRegistryImageVersion string

module keyVault './modules/key-vault.bicep' = {
  name: 'andreiKeyVaultModule'
  params: {
    name: '${name}-kv'
    location: location
  }
}

module containerRegistry './modules/container-registry.bicep' = {
  name: 'andreiAppRegistryModule'
  params: {
    name: name
    location: location
    acrAdminUserEnabled: acrAdminUserEnabled
    adminCredentialsKeyVaultResourceId: keyVault.outputs.keyVaultId
    adminCredentialsKeyVaultSecretUserName: 'acr-admin-username'
    adminCredentialsKeyVaultSecretUserPassword1: 'acr-admin-password1'
    adminCredentialsKeyVaultSecretUserPassword2: 'acr-admin-password2'
  }
}

module appServicePlan './modules/app-service-plan.bicep' = {
  name: 'andreiAppServicePlanModule'
  params: {
    name: '${name}-asp'
    location: location
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
    name: appServiceName
    location: location
    appServicePlanName: appServicePlan.outputs.name
    containerRegistryName: containerRegistry.outputs.loginServer
    containerRegistryImageName: containerRegistryImageName
    containerRegistryImageVersion: containerRegistryImageVersion
    dockerRegistryServerUrl: 'https://${containerRegistry.outputs.loginServer}'
    dockerRegistryServerUserName: listCredentials(resourceId('Microsoft.ContainerRegistry/registries', name), '2019-05-01').username
    dockerRegistryServerPassword: listCredentials(resourceId('Microsoft.ContainerRegistry/registries', name), '2019-05-01').passwords[0].value
  }
}

output containerRegistryLoginServer string = containerRegistry.outputs.loginServer
output appServiceId string = appService.outputs.id
output appServiceName string = appService.outputs.name
output appServiceDefaultHostName string = appService.outputs.defaultHostName

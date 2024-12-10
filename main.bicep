module containerRegistry './modules/container-registry.bicep' = {
  name: 'andreiAppRegistryModule'
  params: {
    name: 'andreiAppRegistry'
    location: resourceGroup().location
    acrAdminUserEnabled: true
    adminCredentialsKeyVaultResourceId: keyVault.outputs.id
    adminCredentialsKeyVaultSecretUserName: 'acr-admin-username'
    adminCredentialsKeyVaultSecretUserPassword1: 'acr-admin-password1'
    adminCredentialsKeyVaultSecretUserPassword2: 'acr-admin-password2'
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
    appServicePlanName: appServicePlan.outputs.name
    containerRegistryName: containerRegistry.outputs.loginServer
    containerRegistryImageName: 'python-flask-app'
    containerRegistryImageVersion: 'latest'
    dockerRegistryServerUrl: 'https://andreiAppRegistry.azurecr.io'
    dockerRegistryServerUserName: listCredentials(containerRegistry.outputs.id, '2019-05-01').username
    dockerRegistryServerPassword: listCredentials(containerRegistry.outputs.id, '2019-05-01').passwords[0].value
  }
}

module keyVault './modules/key-vault.bicep' = {
  name: 'andreiKeyVaultModule'
  params: {
    name: 'AndreiAppRegistry-kv'
    location: resourceGroup().location
  }
}

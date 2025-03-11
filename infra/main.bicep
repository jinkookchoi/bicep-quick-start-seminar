targetScope = 'subscription'

@minLength(3)
@maxLength(11)
param namePrefix string

param location string = deployment().location

var resourceGroupName = 'rg-seminar-${namePrefix}'

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

param allowedIpRules array = []

module stgModule './modules/storage-account.bicep' = {
  name: 'storageDeploy'
  scope: newRG
  params: {
    storagePrefix: namePrefix
    location: location
    allowCrossTenantReplication: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: allowedIpRules
      defaultAction: 'Deny'
    }
  }
}

output storageEndpoint object = stgModule.outputs.storageEndpoint

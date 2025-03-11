@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

param location string

param allowCrossTenantReplication bool = true

param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
}
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

param minimumTlsVersion string = 'TLS1_2'

// resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
resource stg 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    // tenant
    allowCrossTenantReplication: allowCrossTenantReplication
    // network access
    networkAcls: networkAcls
    publicNetworkAccess: publicNetworkAccess
    // minimum tls
    minimumTlsVersion: minimumTlsVersion
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints

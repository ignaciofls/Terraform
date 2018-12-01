resource "azurerm_resource_group" "testRG" {
  name     = "testRG"
  location = "West Europe"
}

resource "azurerm_template_deployment" "testTFPipeline" {
  name                = "testARMdeployment"
  resource_group_name = "${azurerm_resource_group.testRG.name}"

  template_body = <<DEPLOY
{

    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "factoryName": {
            "type": "string",
            "metadata": "Data Factory Name",
            "defaultValue": "myTestDatafactoryv2"
        },
        "AzureBlobStorage1_connectionString": {
            "type": "secureString",
            "metadata": "Secure string for 'connectionString' of 'AzureBlobStorage1'"
        },
        "AzureBlobStorage2_connectionString": {
            "type": "secureString",
            "metadata": "Secure string for 'connectionString' of 'AzureBlobStorage2'"
        },
        "SourceDataset_y3s_properties_typeProperties_fileName": {
            "type": "string",
            "defaultValue": ""
        },
        "SourceDataset_y3s_properties_typeProperties_folderPath": {
            "type": "string",
            "defaultValue": "name1"
        },
        "DestinationDataset_y3s_properties_typeProperties_fileName": {
            "type": "string",
            "defaultValue": ""
        },
        "DestinationDataset_y3s_properties_typeProperties_folderPath": {
            "type": "string",
            "defaultValue": "temp"
        }
    },
    "variables": {
        "factoryId": "[concat('Microsoft.DataFactory/factories/', parameters('factoryName'))]"
    },
    "resources": [
        {
            "name": "[concat(parameters('factoryName'), '/MyCopyPipeline_y3s')]",
            "type": "Microsoft.DataFactory/factories/pipelines",
            "apiVersion": "2018-06-01",
            "properties": {
                "activities": [
                    {
                        "name": "Copy_y3s",
                        "type": "Copy",
                        "dependsOn": [],
                        "policy": {
                            "timeout": "7.00:00:00",
                            "retry": 0,
                            "retryIntervalInSeconds": 30,
                            "secureOutput": false,
                            "secureInput": false
                        },
                        "userProperties": [
                            {
                                "name": "Source",
                                "value": "name1/"
                            },
                            {
                                "name": "Destination",
                                "value": "temp/"
                            }
                        ],
                        "typeProperties": {
                            "source": {
                                "type": "BlobSource",
                                "recursive": false
                            },
                            "sink": {
                                "type": "BlobSink",
                                "copyBehavior": "PreserveHierarchy"
                            },
                            "enableStaging": false,
                            "dataIntegrationUnits": 0
                        },
                        "inputs": [
                            {
                                "referenceName": "SourceDataset_y3s",
                                "type": "DatasetReference",
                                "parameters": {}
                            }
                        ],
                        "outputs": [
                            {
                                "referenceName": "DestinationDataset_y3s",
                                "type": "DatasetReference",
                                "parameters": {}
                            }
                        ]
                    }
                ],
                "annotations": []
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/datasets/SourceDataset_y3s')]",
                "[concat(variables('factoryId'), '/datasets/DestinationDataset_y3s')]"
            ]
        },
        {
            "name": "[concat(parameters('factoryName'), '/SourceDataset_y3s')]",
            "type": "Microsoft.DataFactory/factories/datasets",
            "apiVersion": "2018-06-01",
            "properties": {
                "linkedServiceName": {
                    "referenceName": "AzureBlobStorage1",
                    "type": "LinkedServiceReference"
                },
                "annotations": [],
                "type": "AzureBlob",
                "typeProperties": {
                    "fileName": "[parameters('SourceDataset_y3s_properties_typeProperties_fileName')]",
                    "folderPath": "[parameters('SourceDataset_y3s_properties_typeProperties_folderPath')]"
                }
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/linkedServices/AzureBlobStorage1')]"
            ]
        },
        {
            "name": "[concat(parameters('factoryName'), '/DestinationDataset_y3s')]",
            "type": "Microsoft.DataFactory/factories/datasets",
            "apiVersion": "2018-06-01",
            "properties": {
                "linkedServiceName": {
                    "referenceName": "AzureBlobStorage1",
                    "type": "LinkedServiceReference"
                },
                "annotations": [],
                "type": "AzureBlob",
                "typeProperties": {
                    "fileName": "[parameters('DestinationDataset_y3s_properties_typeProperties_fileName')]",
                    "folderPath": "[parameters('DestinationDataset_y3s_properties_typeProperties_folderPath')]"
                }
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/linkedServices/AzureBlobStorage1')]"
            ]
        },
        {
            "name": "[concat(parameters('factoryName'), '/AzureBlobStorage1')]",
            "type": "Microsoft.DataFactory/factories/linkedServices",
            "apiVersion": "2018-06-01",
            "properties": {
                "annotations": [],
                "type": "AzureBlobStorage",
                "typeProperties": {
                    "connectionString": "[parameters('AzureBlobStorage1_connectionString')]"
                }
            },
            "dependsOn": []
        },
        {
            "name": "[concat(parameters('factoryName'), '/AzureBlobStorage2')]",
            "type": "Microsoft.DataFactory/factories/linkedServices",
            "apiVersion": "2018-06-01",
            "properties": {
                "annotations": [],
                "type": "AzureBlobStorage",
                "typeProperties": {
                    "connectionString": "[parameters('AzureBlobStorage2_connectionString')]"
                }
            },
            "dependsOn": []
        }
    ]
}   
   
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block

  deployment_mode = "Incremental"
}
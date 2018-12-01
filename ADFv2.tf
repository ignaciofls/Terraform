resource "azurerm_resource_group" "testRG" {
  name     = "myRG"
  location = "West Europe"
}

resource "azurerm_template_deployment" "test2" {
  name                = "testARMdeployment"
  resource_group_name = "${azurerm_resource_group.testRG.name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "type": "string",
            "defaultValue": "myNewDatafactoryv2"
        },
        "location": {
            "type": "string",
            "defaultValue": "West Europe"
        },
        "apiVersion": {
            "type": "string",
            "defaultValue": "2018-06-01"
        }
    },
    "resources": [
        {
            "apiVersion": "[parameters('apiVersion')]",
            "name": "[parameters('name')]",
            "location": "[parameters('location')]",
            "type": "Microsoft.DataFactory/factories",
            "identity": {
                "type": "SystemAssigned"
            }
        }
    ]
}
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block

  deployment_mode = "Incremental"
}
resource "azurerm_resource_group" "test" {
  name     = "testRGN"
  location = "West Europe"
}

resource "azurerm_template_deployment" "testWS" {
  name                = "testARMdeployment"
  resource_group_name = "${azurerm_resource_group.test.name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workspaceName": {
            "type": "string",
            "metadata": {
                "description": "The name of the Azure Databricks workspace to create."
            }
        },
        "pricingTier": {
            "type": "string",
            "defaultValue": "premium",
            "allowedValues": [
                "standard",
                "premium"
            ],
            "metadata": {
                "description": "The pricing tier of workspace."
            }
        },
        "location": {
            "type": "string",
            "defaultValue": "[resourceGroup().location]",
            "metadata": {
                "description": "Location for all resources."
            }
        }
    },
    "variables": {
        "managedResourceGroupName": "[concat('databricks-rg-', parameters('workspaceName'), '-', uniqueString(parameters('workspaceName'), resourceGroup().id))]"
    },
    "resources": [
        {
            "type": "Microsoft.Databricks/workspaces",
            "name": "[parameters('workspaceName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2018-04-01",
            "sku": {
                "name": "[parameters('pricingTier')]"
            },
            "properties": {
                "ManagedResourceGroupId": "[concat(subscription().id, '/resourceGroups/', variables('managedResourceGroupName'))]"
            }
        }
    ],
    "outputs": {
        "workspace": {
            "type": "object",
            "value": "[reference(resourceId('Microsoft.Databricks/workspaces', parameters('workspaceName')))]"
        }
    }
}
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters {
        "workspaceName" = "testAutoADB",
        "location" = "westeurope",
        "pricingTier" = "premium"
  }

  deployment_mode = "Incremental"
}
# Terraform
Terraform templates for Azure Databricks (ADB) and Azure Data Factory (ADF). Here you can find examples on how to create a ADB workspace, ADB cluster, ADF instance and ADF pipeline.

Reminder of the steps:

- terraform init
- az login
- check your default browser to login into Azure
- az account set --subscription="your subs ID"
- terraform plan
- terraform apply
- enjoy :)

We recommend using a Service Principal when running in a shared environment (such as within a CI server/automation) - and authenticating via the Azure CLI when you're running Terraform locally

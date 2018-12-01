# Terraform
Terraform templates for Azure Databricks and Azure Data Factory

Reminder of the steps:

- terraform init
- az login
- check your default browser to login into Azure
- az account set --subscription="your subs ID"
- terraform plan
- terraform apply
- enjoy :)



To create a cluster in ADB in an automated fashion you need Azure Active Directory integration feature that is coming December18. In the meanwhile you can work around by:

- terraform init
- az login
- check your default browser to login into Azure
- az account set --subscription="your subs ID"
- copy ADBws.tf in your working folder
- terraform plan
- terraform apply
- connect to workspace and maunally generate a token https://docs.azuredatabricks.net/api/latest/authentication.html#generate-a-token
- install databricks cli locally and use token to authenticate:   https://docs.azuredatabricks.net/user-guide/dev-tools/databricks-cli.html#install-the-cli
- run terraform internally invoking cli: https://docs.azuredatabricks.net/user-guide/dev-tools/databricks-cli.html#clusters-cli  :

resource "null_resource" "cloudability-setup" {
  provisioner "local-exec" {
      command = <<EOT
databricks clusters --json-file PATH
EOT
  }
}  

- enjoy :)

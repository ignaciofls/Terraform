To create a cluster in ADB in an automated fashion you need Azure Active Directory integration feature that is coming December18. In the meanwhile you can work around by:

    terraform init
    az login
    check your default browser to login into Azure
    az account set --subscription="your subs ID"
    copy .tf in your working folder
    terraform plan
    terraform apply
    connect to workspace and manually generate a token (https://docs.azuredatabricks.net/api/latest/authentication.html#generate-a-token)
    install databricks cli locally and use token to authenticate: (https://docs.azuredatabricks.net/user-guide/dev-tools/databricks-cli.html#install-the-cli)
    prepare a json with your new cluster settings: ie 
    {
          "cluster_name": "newcluster",
            "spark_version": "4.0.x-scala2.11",
              "node_type_id": "Standard_D3_v2",
                "autoscale" : {
                            "min_workers": 2,
                                "max_workers": 10
                                  }
    }

    run terraform internally invoking cli: (https://docs.azuredatabricks.net/user-guide/dev-tools/databricks-cli.html#clusters-cli) :

    resource "null_resource" "cloudability-setup" {
      provisioner "local-exec" {
          command = "/home/nacho/.local/bin/databricks clusters create --json-file /etc/test/conf.json"
      }
    }

    enjoy :)

The same local-exec trick can be used to start/terminate clusters, trigger jobs via spark submit, etc all orchestrated by Terraform

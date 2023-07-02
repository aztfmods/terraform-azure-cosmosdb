provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg"

  env = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "cosmosdb" {
  source = "../../"

  workload    = var.workload
  environment = module.global.env

  cosmosdb = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    kind          = "MongoDB"
    capabilities  = ["EnableMongo"]

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
      }
    }

    tables = {
      table1 = {
        throughput = 400
      }
    }

    databases = {
      mongo = {
        db1 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
            }
          }
        }
        db2 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
            }
          }
        }
      }
    }
  }
  depends_on = [module.rg]
}


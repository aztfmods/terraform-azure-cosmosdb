provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    db = { location = "westeurope" }
  }
}

module "cosmosdb" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  cosmosdb = {
    location      = module.global.groups.db.location
    resourcegroup = module.global.groups.db.name

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
      }
    }

    databases = {
      sql = {
        db1 = {
          throughput = 400
          containers = {
            ct1 = {
              throughput       = 400
              unique_key_paths = ["/definition/idlong"]
              index_policy = {
                indexing_mode  = "consistent"
                included_paths = ["/*"]
                excluded_paths = ["/excluded/?", "/another_excluded"]
              }
            }
          }
        }
        db2 = {
          throughput = 400
        }
      }
    }
  }
  depends_on = [module.global]
}

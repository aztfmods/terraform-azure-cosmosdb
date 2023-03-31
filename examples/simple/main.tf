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
    kind          = "MongoDB"

    capabilities = [
      "EnableMongo", "EnableAggregationPipeline",
      "mongoEnableDocLevelTTL", "MongoDBv3.4"
    ]

    geo_location = {
      weu = { location = "westeurope", failover_priority = 1 }
      eus = { location = "eastus", failover_priority = 0 }
    }

    consistency_policy = {
      consistency_level = "BoundedStaleness"
    }
  }
  depends_on = [module.global]
}
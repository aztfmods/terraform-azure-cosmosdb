provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg?ref=v0.1.0"

  environment = var.environment

  groups = {
    demo = { region = "westeurope"
    }
  }
}

module "cosmosdb" {
  source = "github.com/aztfmods/terraform-azure-cosmosdb?ref=v1.4.0"

  workload    = var.workload
  environment = var.environment

  cosmosdb = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    kind          = "MongoDB"
    capabilities  = ["EnableAggregationPipeline"]

    geo_location = {
      weu = { location = "westeurope", failover_priority = 0 }
    }
  }
  depends_on = [module.rg]
}

# Cosmos DB

This Terraform module streamlines the creation and administration of Cosmos DB resources on Azure, offering customizable options for database accounts, consistency levels, throughput settings, and more, to ensure a highly scalable, globally distributed, and secure data management platform in the cloud.

The below features are made available:

- multiple mongo databases and collections
- terratest is used to validate different integrations

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
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
      "EnableMongo",
      "EnableAggregationPipeline",
      "mongoEnableDocLevelTTL",
      "MongoDBv3.4"
    ]

    geo_location = {
      weu = { location = "westeurope", failover_priority = 1 }
      eus = { location = "eastus", failover_priority = 0 }
    }

    consistency_policy = {
      level = "BoundedStaleness"
    }
  }
  depends_on = [module.global]
}
```

## Usage: mongodb

```hcl
module "cosmosdb" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  cosmosdb = {
    location           = module.global.groups.db.location
    resourcegroup      = module.global.groups.db.name
    kind               = "MongoDB"
    consistency_policy = "BoundedStaleness"

    capabilities = [
      "EnableMongo", "MongoDBv3.4",
      "EnableAggregationPipeline",
      "mongoEnableDocLevelTTL",
    ]

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
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
  depends_on = [module.global]
}
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_cosmosdb_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_cosmosdb_mongo_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_cosmosdb_mongo_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `cosmosdb` | describes cosmosdb related configuration | object | yes |
| `company` | contains the company name used, for naming convention | string | yes |
| `region` | contains the shortname of the region, used for naming convention | string | yes |
| `env` | contains shortname of the environment used for naming convention | string | yes |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-cosmosdb/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-cosmosdb/blob/main/LICENSE) for full details.

## Reference

- [Cosmos DB Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/cosmos-db/)
- [Cosmos DB Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/cosmos-db/)

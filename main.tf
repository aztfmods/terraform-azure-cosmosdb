#----------------------------------------------------------------------------------------
# Generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# cosmosdb account
#----------------------------------------------------------------------------------------

resource "azurerm_cosmosdb_account" "db" {
  name                      = "cosmos-${var.company}-${var.env}-${var.region}-${random_string.random.result}"
  location                  = var.cosmosdb.location
  resource_group_name       = var.cosmosdb.resourcegroup
  offer_type                = try(var.cosmosdb.offer_type, "Standard")
  kind                      = try(var.cosmosdb.kind, "GlobalDocumentDB")
  enable_automatic_failover = true

  dynamic "capabilities" {
    for_each = try(var.cosmosdb.capabilities, [])

    content {
      name = capabilities.value
    }
  }

  dynamic "geo_location" {
    for_each = var.cosmosdb.geo_location
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = try(geo_location.value.zone_redundant, false)
    }
  }

  consistency_policy {
    consistency_level       = var.cosmosdb.consistency_policy.level
    max_interval_in_seconds = try(var.cosmosdb.consistency_policy.max_interval_in_seconds, 300)
    max_staleness_prefix    = try(var.cosmosdb.consistency_policy.max_staleness_prefix, 100000)
  }
}
locals {
  mongo_collections = flatten([
    for db_key, db in try(var.cosmosdb.databases.mongo, {}) : [
      for collection_key, collection in try(db.collections, {}) : {
        db_key         = db_key
        collection_key = collection_key
        throughput     = collection.throughput
      }
    ]
  ])
}

locals {
  sql_containers = flatten([
    for db_key, db in try(var.cosmosdb.databases.sql, {}) : [
      for container_key, container in try(db.containers, {}) : {
        db_key        = db_key
        container_key = container_key
        throughput    = container.throughput
        indexing_mode = container.index_policy.indexing_mode
        included_path = container.index_policy.included_paths
        excluded_path = container.index_policy.excluded_paths
        unique_key    = container.unique_key_paths
      }
    ]
  ])
}

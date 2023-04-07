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
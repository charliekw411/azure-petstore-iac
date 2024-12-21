module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  name     = local.resource_group_name
  location = var.location

  tags = local.default_tags

}

output "name" {
  value = module.resource_group.name
}

# # terraform state storage
# module "storage_account" {
#   source  = "Azure/avm-res-storage-storageaccount/azurerm"
#   version = "0.2.7"

#   name                = local.storage_account_name
#   resource_group_name = module.resource_group.name
#   location            = var.location

#   account_replication_type = "LRS"
#   account_tier             = "Standard"

#   containers = {
#     "tfstate" = {
#       name        = "tfstate"
#       access_type = "private"
#     }
#   }

#   tags = local.default_tags
# }
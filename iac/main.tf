# get info about the Azure tenant
data "azurerm_client_config" "current" {}

# TODO: uncomment after pipeline is setup
# get info about the service principal.
# data "azuread_service_principal" "logged_in_app" {
#   client_id = data.azurerm_client_config.current.client_id
# }

# Get info about the resource group the solution is deployed into
data "azurerm_resource_group" "parent" {
  name       = local.resource_group_name
  depends_on = [module.resource_group]
}

data "azurerm_resource_group" "core" {
  name       = local.resource_group_name
  depends_on = [module.resource_group]
}
# ACR will store the Docker images for the petstore application microservices.
module "containerregistry" {
    source = "Azure/avm-res-containerregistry-registry/azurerm"
    name = local.container_registry_name
    resource_group_name = module.resource_group.name
    location = var.location

    # this is so that the web app can access the ACR
    admin_enabled = true
}

# data sources to retrieve the ACR admin username and password
data "azurerm_container_registry" "acr" {
    name = module.containerregistry.resource.name
    resource_group_name = local.resource_group_name

    # ensure this data source depends on the ACR being created first
    depends_on = [module.containerregistry]
}

# Output the ACR admin username and password to use in the App Service module
output "acr_admin_username" {
    value = data.azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
    value = data.azurerm_container_registry.acr.admin_password
}
# This file is used to create the App Service Plan and App Service
module "avm-res-web-serverfarm" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "0.2.0"

  location = var.location
  name    = local.app_service_plan_name
  os_type = local.os_type
  resource_group_name = local.resource_group_name
}

module "avm-res-web-site" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.10.0"

  name                = local.webapp_name
  location            = local.location
  os_type             = local.os_type
  kind                = "webapp" 
  resource_group_name = local.resource_group_name

  service_plan_resource_id = module.avm-res-web-serverfarm.resource_id

  site_config = {
    always_on = true
    linux_fx_version = "COMPOSE|/home/site/wwwroot/docker-compose.yaml" # tells the app service to execute the docker-compose.yaml file at this path.
  }                                                                      # it is placed here by the pipeline

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL = "https://acrpetstoredev01.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = data.azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = data.azurerm_container_registry.acr.admin_password
  }

  # Disable Application Insights
  enable_application_insights = false
}
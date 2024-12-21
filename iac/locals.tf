locals {
  short_location_code  = "auea"
  default_suffix       = "${var.appname}-${local.short_location_code}"
  default_short_suffix = "${var.short_appname}${var.env_code}${local.short_location_code}"

  # add resource names here, using CAF-aligned naming conventions
  resource_group_name     = "rg-${local.default_suffix}"
  storage_account_name    = "sttf${var.short_appname}${var.env_code}01"
  container_registry_name = "acr${var.short_appname}${var.env_code}01"
  app_service_plan_name   = "asp-${local.default_short_suffix}"
  os_type                 = "Linux"
  webapp_name             = "webapp-${local.default_short_suffix}"

  # key_vault_name           = "kv-${local.default_short_suffix}"
  environment = var.env_code

  location = var.location

  default_tags = merge(
    var.default_tags,
    tomap({
      # TODO: uncomment after pipeline is setup    
      #   "CreatedBy"   = data.azuread_service_principal.logged_in_app.display_name
      "Environment" = var.env_code
    })
  )
}
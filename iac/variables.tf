

variable "appname" {
  description = "The longer name of the application used for naming conventions."
  type        = string
}

variable "short_appname" {
  description = "The short name of the application used for naming conventions."
  type        = string
}

variable "env_code" {
  description = "The environment code (e.g., dev, prod)."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources should be deployed."
  type        = string
}

variable "default_tags" {
  description = "Tags to be applied to the resources."
  type        = map(string)
}

# # variables shared across all resources
# variable "appname" {
#   description = "Longer name of the application used for naming conventions."
#   type        = string
# }

# variable "short_appname" {
#   description = "Short name of the application used for naming conventions."
#   type        = string
#   validation {
#     # this is assuming that an environment name will be 4 characters or less - example for a storage account - st12345678901234prodae01
#     condition     = length(var.short_appname) <= 14
#     error_message = "Err: The short_appname should be 14 characters or less to fit within naming conventions for resources such as storage accounts."
#   }
# }

# variable "short_location_code" {
#   description = "A short form of the location where resource are deployed, used in naming conventions."
#   type        = string
#   default     = "auea"
# }

# variable "env_code" {
#   description = "Short name of the environment used for naming conventions (e.g. dev, test, prod)."
#   type        = string
#   validation {
#     condition = contains(
#       ["dev", "test", "uat", "prod"],
#       var.env_code
#     )
#     error_message = "Err: environment should be one of dev, test or prod."
#   }
#   validation {
#     condition     = length(var.env_code) <= 4
#     error_message = "Err: environment code should be 4 characters or shorter."
#   }
# }

# # tags are expected to be provided
# variable "default_tags" {
#   description = <<DESCRIPTION
# Tags to be applied to resources.  Default tags are expected to be provided in local.default_tags, 
# which is merged with environment specific ones in ``environments\env.terraform.tfvars``.
# Most resources will simply apply the default tags like this:

# ```terraform
# tags = local.default_tags
# ```

# Additional tags can be provided by using a merge, for instance:

# ```terraform
# tags = merge(
#     local.default_tags,
#     tomap({
#       "MyExtraResourceTag" = "TheTagValue"
#     })
# )
# ```

# Note you can also use the above mechanims to override or modify the default tags for an individual resource,
# since only unique items in a map are retained, and later tags supplied to merge() function take precedence.
# DESCRIPTION
#   type        = map(string)
#   default     = {}
# }

# ## Resource Group Variables
# variable "resource_group_name" {
#   description = "The name of the resource group"
#   type        = string
# }
# variable "environment" {
#   description = "The environment name"
#   type        = string
#   default = "dev"
# }
# variable "location" {
#   type        = string
#   description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
#   nullable    = false
# }

# variable "name" {
#   type        = string
#   description = "(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
#   nullable    = false
# }

# variable "managed_by" {
#   type        = string
#   default     = null
#   description = "(Optional) The ID of the resource or application that manages this Resource Group."
# }

# variable "tags" {
#   type        = map(string)
#   default     = null
#   description = "(Optional) A mapping of tags which should be assigned to the Resource Group."
# }

# variable "timeouts" {
#   type = object({
#     create = optional(string)
#     delete = optional(string)
#     read   = optional(string)
#     update = optional(string)
#   })
#   default     = null
#   description = <<-EOT
#  - `create` - (Defaults to 90 minutes) Used when creating the Resource Group.
#  - `delete` - (Defaults to 90 minutes) Used when deleting the Resource Group.
#  - `read` - (Defaults to 5 minutes) Used when retrieving the Resource Group.
#  - `update` - (Defaults to 90 minutes) Used when updating the Resource Group.
# EOT
# }

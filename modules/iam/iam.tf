##   Terraform to set up a VNET for CDP Public Cloud w/ CCM (Private IPs) enabled
##   michael.arnold@clairvoyantsoft.com

## This TF will create the following artifacts in your Azure IAM:
## 4x Managed Identities:
## - ASSUMER
## - LOGGER
## - DATA_LAKE_ADMIN
## - RANGER_AUDIT_LOGGER
## 5x Role Assignments:


## INPUTS:
## - REQUIRED - Name of the bucket that will contain your datalake
## - REQUIRED - Azure region where everything will be created
## - REQUIRED - Name of the storage account
## - REQUIRED - Name of the storage filesystem
## - REQUIRED - Name of the logs filesystem
## - OPTIONAL - A prefix to be given to your objects
## WILL BE DIVINED:
## - Azure subscription

## All artifact are named as per CDP Public Cloud Documentation
## https://docs.cloudera.com/management-console/cloud/environments-azure/topics/mc-az-minimal-setup-for-cloud-storage.html

# If you want the generated artifacts to have a prefix to their name, then
# specify by using -var argument on the command line
# e.g. terraform appy -var="PREFIX=MyPrefix_"


### THESE VARIABLES WILL BE REQUESTED ON THE COMMAND LINE
variable "DATALAKE" {
  type = string
  description = <<EOF
  Enter the bucket name for the datlake (without a leading  s3:// or a trailing /).
  - Datalake location will be {bucketname}/
  - Logs location will be {bucketname}/logs
  - DynamoDB table will be {bucketname}* (e.g. {bucketname}, {bucketname}-s3a etc.)
  EOF
}

variable "LOCATION" {
  type = string
  description = "Azure Region for the resource group"
}

variable "STORAGE_ACCOUNT" {}
variable "STORAGE" {}
variable "LOGS" {}

### THESE VARIABLES CAN BE SET BY COMMAND LINE FLAGS
### shellprompt$ terraform apply -var="PREFIX=MyPrefix_"

variable "PREFIX" {
  default = ""
  description = "Prefix for names of created objects (e.g. CDPPOC_)"
}

data "azurerm_subscription" "primary" {}

data "azurerm_storage_container" "logs" {
  name                 = var.LOGS
  storage_account_name = var.STORAGE_ACCOUNT
}

data "azurerm_storage_container" "storage" {
  name                 = var.STORAGE
  storage_account_name = var.STORAGE_ACCOUNT
}


resource "azurerm_resource_group" "the_rg" {
  name     = "${var.PREFIX}cdp-rg"
  location = var.LOCATION
}

resource "azurerm_user_assigned_identity" "assumer" {
  name                = "${var.PREFIX}assumer"
  resource_group_name = azurerm_resource_group.the_rg.name
  location            = var.LOCATION
}

resource "azurerm_user_assigned_identity" "datalakeadmin" {
  name                = "${var.PREFIX}data_lake_admin"
  resource_group_name = azurerm_resource_group.the_rg.name
  location            = var.LOCATION
}

resource "azurerm_user_assigned_identity" "ranger" {
  name                = "${var.PREFIX}ranger_audit_logger"
  resource_group_name = azurerm_resource_group.the_rg.name
  location            = var.LOCATION
}

resource "azurerm_user_assigned_identity" "logger" {
  name                = "${var.PREFIX}logger"
  resource_group_name = azurerm_resource_group.the_rg.name
  location            = var.LOCATION
}

resource "azurerm_role_assignment" "assumerV" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.assumer.principal_id
}

resource "azurerm_role_assignment" "assumerM" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.assumer.principal_id
}

resource "azurerm_role_assignment" "datalakeadminS" {
  scope                = data.azurerm_storage_container.storage.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.datalakeadmin.principal_id
}

resource "azurerm_role_assignment" "datalakeadminL" {
  scope                = data.azurerm_storage_container.logs.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.datalakeadmin.principal_id
}

resource "azurerm_role_assignment" "ranger" {
  scope                = data.azurerm_storage_container.storage.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.ranger.principal_id
}

resource "azurerm_role_assignment" "logger" {
  scope                = data.azurerm_storage_container.logs.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.logger.principal_id
}


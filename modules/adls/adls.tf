##   Terraform to set up a ADLS Gen2 storage account and filesystems for CDP datalake
##   michael.arnold@clairvoyantsoft.com

### Create the storage account
### Create logs filesystem and datalake filesystem


### THESE VARIABLES WILL BE REQUESTED ON THE COMMAND LINE
variable "DATALAKE" {
  type = string
  description = <<EOF
  Enter the name for the datalake (without the leading  abfs://).
  Default encryption will be enabled (even for pre-existing filesystem)
   NOTE: terraform destroy WILL destroy the filesystem, even if it pre-existed
  EOF
}


### THESE VARIABLES CAN BE SET BY COMMAND LINE FLAGS
### shellprompt$ terraform apply -var="PREFIX=MyPrefix_"

variable "PREFIX" {
  default = ""
  description = "Prefix for names of created objects (e.g. CDPPOC_)"
}

variable "RG" {}

variable "LOCATION" {
  description = "Azure Region for the resource group"
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

resource "azurerm_storage_account" "the_sa" {
  name                      = lower(replace("${var.PREFIX}${var.DATALAKE}", "/[^0-9A-Za-z]/", ""))
  location                  = var.LOCATION
  resource_group_name       = var.RG
  account_kind              = "StorageV2"
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = true
  is_hns_enabled            = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storage" {
  name               = "storage-fs"
  storage_account_id = azurerm_storage_account.the_sa.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "logs" {
  name               = "logs-fs"
  storage_account_id = azurerm_storage_account.the_sa.id
}


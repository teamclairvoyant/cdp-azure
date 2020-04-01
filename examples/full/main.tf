module "cdp-vnet" {
  source = "../../modules/vnet"

  PREFIX = var.deployment_name_prefix
  VNET_CIDR = var.vnet_cidr
  subnets = var.subnets
  RG = module.cdp-iam.resource_group
  LOCATION = var.location
}

module "cdp-adls" {
  source = "../../modules/adls"

  PREFIX = var.deployment_name_prefix
  DATALAKE = var.bucket_name
  RG = module.cdp-iam.resource_group
  LOCATION = var.location
}

module "cdp-iam" {
  source = "../../modules/iam"

  PREFIX = var.deployment_name_prefix
  DATALAKE = var.bucket_name
  LOCATION = var.location
  LOGS = module.cdp-adls.filesystem_logs
  STORAGE = module.cdp-adls.filesystem_storage
  STORAGE_ACCOUNT = module.cdp-adls.storage_account
}


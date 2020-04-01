output "network" {
  description = "Network name."
  value = module.cdp-vnet.azure_vnet
}

output "LOGGER_IDENTITY" {
  description = "Logs Storage and Audits - Instance Profile."
  value = module.cdp-iam.log
}

output "logs-location-base" {
  description = "Logs Storage and Audits - Logs Location Base."
  value = "${module.cdp-adls.filesystem_logs}@${module.cdp-adls.storage_account}"
}

output "RANGER_AUDIT_IDENTITY" {
  description = "Logs Storage and Audits - Ranger Audit Role."
  value = module.cdp-iam.ranger
}

output "ASSUMER_IDENTITY" {
  description = "Data Access - Instance Profile."
  value = module.cdp-iam.assumer
}

output "storage-location-base" {
  description = "Data Access - Storage Locatioon Base."
  value = "${module.cdp-adls.filesystem_storage}@${module.cdp-adls.storage_account}"
}

output "DATALAKE_ADMIN_IDENTITY" {
  description = "Data Access - Data Access Role."
  value = module.cdp-iam.datalake_admin
}


output "storage_account" {
  value = azurerm_storage_account.the_sa.name
}

output "filesystem_storage" {
  value = azurerm_storage_data_lake_gen2_filesystem.storage.name
}

output "filesystem_logs" {
  value = azurerm_storage_data_lake_gen2_filesystem.logs.name
}


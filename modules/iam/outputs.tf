output "resource_group" {
  value = azurerm_resource_group.the_rg.name
}

output "assumer" {
  value = azurerm_user_assigned_identity.assumer.name
}

output "datalake_admin" {
  value = azurerm_user_assigned_identity.datalakeadmin.name
}

output "ranger" {
  value = azurerm_user_assigned_identity.ranger.name
}

output "log" {
  value = azurerm_user_assigned_identity.logger.name
}


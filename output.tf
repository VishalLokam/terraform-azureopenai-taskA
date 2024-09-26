output "azureopenai_resource_group" {
  value = azurerm_resource_group.azureopenai_rg.name
}
output "azureopenai_deployment_id" {
  value = azurerm_cognitive_deployment.azureopenai_cognitive_deployment.id
}

output "azureopenai_deployment_name" {
  value = azurerm_cognitive_deployment.azureopenai_cognitive_deployment.name
}

output "azureopenai_account_id" {
  value = azurerm_cognitive_account.azureopenai_cognitive_account.id
}

output "azureopenai_account_name" {
  value = azurerm_cognitive_account.azureopenai_cognitive_account.name
}

output "endpoint" {
  value = azurerm_cognitive_account.azureopenai_cognitive_account.endpoint
}





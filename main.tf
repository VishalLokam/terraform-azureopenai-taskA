resource "azurerm_resource_group" "azureopenai_rg" {
  name     = "azureopenai_rg"
  location = var.location
}

# public_network_access_enabled set to false to restrict access from the internet.
# outbound_network_access_restricted set to true to deny access exceptions from trusted services.
# custom_subdomain_name required for private endpoint.
resource "azurerm_cognitive_account" "azureopenai_cognitive_account" {
  resource_group_name                = azurerm_resource_group.azureopenai_rg.name
  name                               = "azureopenai_cognitive_account"
  kind                               = "OpenAI"
  location                           = var.location
  sku_name                           = "S0"
  public_network_access_enabled      = false
  outbound_network_access_restricted = true
  custom_subdomain_name              = var.custom_subdomain_name
}

# deployment named "gpt35turbo_0125_deployment" inside the cognitive account.
# model used is openai gpt-3.5-turbo(0125)
# sku is standard with 50k token per minute(TPM) limit. 1 capacity = 1k TPM
resource "azurerm_cognitive_deployment" "azureopenai_cognitive_deployment" {
  name                 = var.deployment_name
  cognitive_account_id = azurerm_cognitive_account.azureopenai_cognitive_account.id

  model {
    format  = "OpenAI"
    name    = var.model_name
    version = "0125"
  }

  sku {
    name     = "Standard"
    capacity = 50
  }

}

# create a new virtual network
resource "azurerm_virtual_network" "azureopenai_vn" {
  name                = "azureopenai_vn"
  resource_group_name = azurerm_resource_group.azureopenai_rg.name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
}

# create a new subnet inside "azureopenai_vn" virtual network
resource "azurerm_subnet" "azureopenai_subnet" {
  name                 = "azureopenai_subnet"
  resource_group_name  = azurerm_resource_group.azureopenai_rg.name
  virtual_network_name = azurerm_virtual_network.azureopenai_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

# private dns zone name should be from the below documentation
# https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#ai--machine-learning
resource "azurerm_private_dns_zone" "azureopenai_dns_zone" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.azureopenai_rg.name
}

# linking private dns zone to virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "azureopenai_dns_zone_vn_link" {
  name                  = "azureopenai_dns_zone_vn_link"
  resource_group_name   = azurerm_resource_group.azureopenai_rg.name
  virtual_network_id    = azurerm_virtual_network.azureopenai_vn.id
  private_dns_zone_name = azurerm_private_dns_zone.azureopenai_dns_zone.name
  registration_enabled  = true
  depends_on            = [azurerm_virtual_network.azureopenai_vn, azurerm_private_dns_zone.azureopenai_dns_zone]
}

# Create private endpoint to connect to the cognitive account 
resource "azurerm_private_endpoint" "azureopenai_private_endpoint" {
  name                = "azureopenai_private_endpoint"
  resource_group_name = azurerm_resource_group.azureopenai_rg.name
  subnet_id           = azurerm_subnet.azureopenai_subnet.id
  location            = var.location

  private_service_connection {
    name                           = "azureopenai_private_connection"
    private_connection_resource_id = azurerm_cognitive_account.azureopenai_cognitive_account.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "azureopenai_dns_zone_group"
    private_dns_zone_ids = [azurerm_private_dns_zone.azureopenai_dns_zone.id]
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.azureopenai_dns_zone_vn_link]

}

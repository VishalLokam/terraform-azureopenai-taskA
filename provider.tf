terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "f3a0be4d-7a41-4def-9e34-ccfeb5a710a0"
}

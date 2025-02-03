terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "crc-test-terraform" {
  name     = "crc-test-terraform"
  location = "Canada Central"
  tags = {
    environment = "test"
  }
}

resource "azurerm_storage_account" "sa-crc-test" {
  name                     = "sacrctest"
  resource_group_name      = azurerm_resource_group.crc-test-terraform.name
  location                 = azurerm_resource_group.crc-test-terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
  custom_domain {
    name = "terraform.arvinjosol.ca"
  }
  tags = {
    environment = "test"
  }
}
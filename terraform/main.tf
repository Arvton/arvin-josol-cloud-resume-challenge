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
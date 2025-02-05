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

resource "azurerm_storage_account" "sa2-crc-test" {
  name                     = "sa2crctest"
  resource_group_name      = azurerm_resource_group.crc-test-terraform.name
  location                 = azurerm_resource_group.crc-test-terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
  #   custom_domain {
  #     name = "terraform.arvinjosol.ca"
  #   }
  tags = {
    environment = "test"
  }
}

resource "azurerm_storage_blob" "blob-crc-scripts-test" {
  for_each = fileset(path.module, "../scripts/*")

  name                   = trim(each.key, "../")
  storage_account_name   = azurerm_storage_account.sa2-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/javascript"
  source                 = each.key
}

resource "azurerm_storage_blob" "blob-crc-styles-index-test" {
  name                   = "styles/index.css"
  storage_account_name   = azurerm_storage_account.sa2-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/css"
  source                 = "../styles/index.css"
}

resource "azurerm_storage_blob" "blob-crc-styles-assets-test" {
  name                   = "styles/assets/icons/new-tab.png"
  storage_account_name   = azurerm_storage_account.sa2-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "image/png"
  source                 = "../styles/assets/icons/new-tab.png"
}

resource "azurerm_storage_blob" "blob-crc-index-test" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa2-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../index.html"
}

resource "azurerm_storage_blob" "blob-crc-404-test" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.sa2-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../404.html"
}
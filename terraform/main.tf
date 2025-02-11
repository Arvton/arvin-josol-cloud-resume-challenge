terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  type      = string
  sensitive = true
}

provider "azurerm" {
  features {}
}

provider "digitalocean" {
  token = var.do_token
}

resource "random_string" "test-randomizer" {
  length  = 7
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "digitalocean_record" "terraform" {
  domain = "arvinjosol.ca"
  type   = "CNAME"
  name   = random_string.test-randomizer.result
  value  = "${azurerm_cdn_endpoint.cdn-ep-crc-test.fqdn}."
}

resource "azurerm_resource_group" "crc-test-terraform" {
  name     = "rg-crc-${random_string.test-randomizer.result}"
  location = "Canada Central"
  tags = {
    environment = "test"
  }
}

resource "azurerm_storage_account" "sa-crc-test" {
  name                     = "sacrc${random_string.test-randomizer.result}"
  resource_group_name      = azurerm_resource_group.crc-test-terraform.name
  location                 = azurerm_resource_group.crc-test-terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_storage_blob" "blob-crc-scripts-test" {
  for_each = fileset(path.module, "../scripts/*")

  name                   = trim(each.key, "../")
  storage_account_name   = azurerm_storage_account.sa-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/javascript"
  source                 = each.key
}

resource "azurerm_storage_blob" "blob-crc-styles-index-test" {
  name                   = "styles/index.css"
  storage_account_name   = azurerm_storage_account.sa-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/css"
  source                 = "../styles/index.css"
}

resource "azurerm_storage_blob" "blob-crc-styles-assets-test" {
  name                   = "styles/assets/icons/new-tab.png"
  storage_account_name   = azurerm_storage_account.sa-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "image/png"
  source                 = "../styles/assets/icons/new-tab.png"
}

resource "azurerm_storage_blob" "blob-crc-index-test" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../index.html"
}

resource "azurerm_storage_blob" "blob-crc-404-test" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.sa-crc-test.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../404.html"
}

resource "azurerm_cdn_profile" "cdn-profile-crc-test" {
  name                = "prof-${random_string.test-randomizer.result}"
  location            = "global"
  resource_group_name = azurerm_resource_group.crc-test-terraform.name
  sku                 = "Standard_Microsoft"

  tags = {
    environment = "test"
  }
}

# resource "random_string" "cdn-ep-name" {
#   length  = 13
#   lower   = true
#   numeric = false
#   special = false
#   upper   = false
# }

resource "azurerm_cdn_endpoint" "cdn-ep-crc-test" {
  name                          = "ep-${random_string.test-randomizer.result}"
  profile_name                  = azurerm_cdn_profile.cdn-profile-crc-test.name
  location                      = "global"
  resource_group_name           = azurerm_resource_group.crc-test-terraform.name
  is_http_allowed               = true
  is_https_allowed              = true
  querystring_caching_behaviour = "IgnoreQueryString"
  is_compression_enabled        = true
  content_types_to_compress = [
    "application/eot",
    "application/font",
    "application/font-sfnt",
    "application/javascript",
    "application/json",
    "application/opentype",
    "application/otf",
    "application/pkcs7-mime",
    "application/truetype",
    "application/ttf",
    "application/vnd.ms-fontobject",
    "application/xhtml+xml",
    "application/xml",
    "application/xml+rss",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-httpd-cgi",
    "application/x-javascript",
    "application/x-mpegurl",
    "application/x-opentype",
    "application/x-otf",
    "application/x-perl",
    "application/x-ttf",
    "font/eot",
    "font/ttf",
    "font/otf",
    "font/opentype",
    "image/svg+xml",
    "text/css",
    "text/csv",
    "text/html",
    "text/javascript",
    "text/js",
    "text/plain",
    "text/richtext",
    "text/tab-separated-values",
    "text/xml",
    "text/x-script",
    "text/x-component",
    "text/x-java-source",
  ]

  origin_host_header = azurerm_storage_account.sa-crc-test.primary_web_host
  origin {
    name      = "origin"
    host_name = azurerm_storage_account.sa-crc-test.primary_web_host
  }
  
  tags = {
    environment = "test"
  }
}

resource "azurerm_cdn_endpoint_custom_domain" "cdn-ep-cd-crc-test" {
  name            = random_string.test-randomizer.result # where is this used?
  cdn_endpoint_id = azurerm_cdn_endpoint.cdn-ep-crc-test.id
  host_name       = digitalocean_record.terraform.fqdn #the custom domain I want to use

  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
  }
}
terraform {
  required_providers {
    azurerm={
        source = "hashicorp/azurerm"
    }
    azapi={
        source = "azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

resource "random_pet" "random"{
  separator = ""
  length = 2
}

resource "azurerm_resource_group" "rg" {
  name="rg-${random_pet.random.id}"
  location = var.location
}

resource "azurerm_api_management" "apim" {
  name="apim${random_pet.random.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  publisher_name = "Mumu Corp"
  publisher_email = "mumu@corp.internet"
  sku_name = "Developer_1"
}

resource "azurerm_api_management_api_version_set" "apimvs" {
  name="apim${random_pet.random.id}vs"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  display_name = "Example APIs"
  versioning_scheme = "Segment"
}

resource "azurerm_api_management_api" "apim_api_v1" {
  name="apim${random_pet.random.id}api_v1"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision = 1
  display_name = "Example API"
  path = "examples"
  version = "v1"
  version_set_id = azurerm_api_management_api_version_set.apimvs.id
  protocols = ["http", "https"]
  import {
    content_format = "openapi+json"
    content_value = file("${path.module}/swagger.v1.json")
  }
}

resource "azurerm_api_management_api" "apim_api_v2" {
  name="apim${random_pet.random.id}api_v2"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision = 1
  display_name = "Example API"
  path = "examples"
  version = "v2"
  version_set_id = azurerm_api_management_api_version_set.apimvs.id
  protocols = ["http", "https"]
  import {
    content_format = "openapi+json"
    content_value = file("${path.module}/swagger.v2.json")
  }
}

resource "azurerm_api_management_api" "apim_api_v3" {
  name="apim${random_pet.random.id}api_v2"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision = 1
  display_name = "Example API"
  path = "examples"
  version = "v3"
  version_set_id = azurerm_api_management_api_version_set.apimvs.id
  protocols = ["http", "https"]
  import {
    content_format = "openapi+json"
    content_value = file("${path.module}/swagger.v3.json")
  }
}
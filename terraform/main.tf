terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
  required_version = "~>1.12.2"
}

provider "azurerm" {
  features {}
  subscription_id = var.subs-id
}

resource "random_integer" "rand" {
  min = var.numeros["min"]
  max = var.numeros["max"]
}

resource "azurerm_storage_account" "origin" {
  name                     = "storageorigin${random_integer.rand.result}"
  resource_group_name      = data.azurerm_resource_group.local.name
  location                 = data.azurerm_resource_group.local.location
  account_tier             = var.storageaccount["account_tier"]
  account_replication_type = var.storageaccount["account_replication_type"]
}

resource "azurerm_storage_account" "dest" {
  name                     = "storagedest${random_integer.rand.result}"
  resource_group_name      = data.azurerm_resource_group.local.name
  location                 = data.azurerm_resource_group.local.location
  account_tier             = var.storageaccount["account_tier"]
  account_replication_type = var.storageaccount["account_replication_type"]
}

resource "azurerm_storage_container" "origin" {
  name                  = var.storagecontainer["name-o"]
  storage_account_id    = azurerm_storage_account.origin.id
  container_access_type = var.storagecontainer["container_access_type"]
}

resource "azurerm_storage_container" "dest" {
  name                  = var.storagecontainer["name-d"]
  storage_account_id    = azurerm_storage_account.dest.id
  container_access_type = var.storagecontainer["container_access_type"]
}

resource "azurerm_service_plan" "plan" {
  name                = var.servicesplan["name"]
  resource_group_name = data.azurerm_resource_group.local.name
  location            = data.azurerm_resource_group.local.location
  os_type             = var.servicesplan["os_type"]
  sku_name            = var.servicesplan["sku_name"]
}

resource "azurerm_linux_function_app" "func" {
  name                       = "func-copy-${random_integer.rand.result}"
  location                   = data.azurerm_resource_group.local.location
  resource_group_name        = data.azurerm_resource_group.local.name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.origin.name
  storage_account_access_key = azurerm_storage_account.origin.primary_access_key

  identity {
    type = var.indentity["type"]
  }

  site_config {
    application_stack {
      python_version = var.pythonconfig["python_version"]
    }
  }

  app_settings = {
    AzureWebJobsStorage      = azurerm_storage_account.origin.primary_connection_string
    ORIGIN_CONTAINER         = azurerm_storage_container.origin.name
    DESTINATION_CONTAINER    = azurerm_storage_container.dest.name
    DESTINATION_CONNECTION   = azurerm_storage_account.dest.primary_connection_string
    FUNCTIONS_WORKER_RUNTIME = var.pythonconfig["python_runtime"]
  }
}

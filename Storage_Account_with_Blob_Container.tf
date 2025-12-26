terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id       = "66387247-dfc9-43bc-9960-01bfd6716cbe"
  subscription_id = "8af2ef0e-975a-40ab-b93d-e004ad679781"
  client_id       = "3a3051fc-278e-4ddf-9832-5a8762ac0c87"
  client_secret   = "WVD8Q~TTJ1EA2qtv2_CKQfAuwow5mdEZhfsnpbZs"
}

# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "venky_rg" {
  name     = "venky-resource-group"
  location = "Central India"
}

# ---------------------------
# Storage Account
# ---------------------------
resource "azurerm_storage_account" "venky_storage" {
  name                     = "venkystorageacc1234"     # must be globally unique, lowercase only
  resource_group_name      = azurerm_resource_group.venky_rg.name
  location                 = azurerm_resource_group.venky_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"                      # LRS / GRS / RAGRS / ZRS
  allow_blob_public_access = true

  tags = {
    Name = "venky-storage"
  }
}

# ---------------------------
# Blob Container
# ---------------------------
resource "azurerm_storage_container" "venky_blob_container" {
  name                  = "venky-container"
  storage_account_name = azurerm_storage_account.venky_storage.name
  container_access_type = "private"   # private / blob / container
}

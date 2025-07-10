# backend.tf
#before using this backend file make sure to create all these service in the cloud 1st

terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"             # create manually or via az CLI
    storage_account_name = "tfsamplebackend12345"      # must be globally unique!
    container_name       = "tfstate"
    key                  = "example-vm.tfstate"
  }
}

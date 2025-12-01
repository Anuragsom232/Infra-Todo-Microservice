terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.50.0"
    }
  }
}

provider "azurerm" {
  features {
      key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "fb192f5a-b2bf-4227-89bf-de8c273d09ac"
  } 
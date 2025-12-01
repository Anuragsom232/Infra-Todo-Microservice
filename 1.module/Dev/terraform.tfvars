resource_groups = {
  RG1 = {
    name       = "citiustech1-RG"
    location   = "southindia"
    managed_by = "Dev-Team"
    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

network_security_groups = {
  NSG1 = {
    name                = "citiustech-NSG"
    location            = "southindia"
    resource_group_name = "citiustech-RG"
    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

virtual_networks = {
  VNET1 = {
    name                = "citiustech-VNET"
    location            = "southindia"
    resource_group_name = "citiustech-RG"
    address_space       = ["10.0.0.0/16"]
    dns_servers         = ["10.0.0.4", "10.0.0.5"]
    subnets = {
      Subnet1 = {
        name             = "citiustech-Subnet1"
        address_prefixes = ["10.0.1.0/24"]
        security_group   = "NSG1"
      }
      Subnet2 = {
        name             = "citiustech-Subnet2"
        address_prefixes = ["10.0.2.0/24"]
      }
    }
    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

key_vaults = {
  kv1 = {
    name                        = "citiustech-kv"
    location                    = "southindia"
    resource_group_name         = "citiustech-RG"
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"
    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

user_assigned_identities = {
  UAI1 = {
    name                = "citiustechuai"
    location            = "southindia"
    resource_group_name = "citiustech-RG"
  }
}

sql_servers = {
  sql01 = {
    name                         = "prod-sql01"
    resource_group_name          = "citiustech-RG"
    location                     = "southindia"
    version                      = "12.0"
    administrator_login          = "akssqladmin"
    administrator_login_password = "P@ssword1234!"
    minimum_tls_version          = "1.2"
    allow_access_to_azure_services = true
    
    identity = {
      identity_keys = ["UAI1"]
    }

    azuread_administrator = {
      login_username = "sasd430536outlook.onmicrosoft.com"
      object_id      = "e7ccb564-6ae8-441a-86cf-0a739ac3cda1"
    }
    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

sql_databases = {
  db01 = {
    name = "customerdb"
    collation      = "SQL_Latin1_General_CP1_CI_AS"
    license_type   = "LicenseIncluded"
    max_size_gb    = 20
    read_scale     = false
    sku_name       = "S0"
    zone_redundant = false
    enclave_type   = "VBS"
    server_key     = "sql01"   

    identity = {
      identity_ids = ["UAI1"]
    }

    prevent_destroy = false

    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

container_registries = {
  acr01 = {
    name                = "citiustechacr"
    resource_group_name = "citiustech-RG"
    location            = "southindia"
    sku                 = "Standard"
    admin_enabled       = true
    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
    }
}

kubernetes_clusters = {
  aks01 = {
    name                = "citiustech-aks"
    resource_group_name = "citiustech-RG"
    location            = "southindia"
    dns_prefix          = "citiustech"
    acr_key             = "acr01" # 🔥 Required for Role Assignment (must match container_registries key)

    default_node_pool = {
      name       = "agentpool"
      node_count = 1
      vm_size    = "Standard_DS2_v2"
    }

    identity = {
      type = "SystemAssigned"
    }

    tags = {
      environment = "Development"
      project     = "MicroServiceApp"
    }
  }
}

subs-id = "4dc63939-80f6-4f50-bd19-bc605cf2786d"

numeros = {
  "min" = "10000"
  "max" = "99999"
}

storageaccount = {
  "account_tier"             = "Standard"
  "account_replication_type" = "LRS"
}

storagecontainer = {
  "name-o"                = "origen"
  "name-d"                = "destino"
  "container_access_type" = "private"
}


servicesplan = {
  "name"     = "function-copy-plan"
  "os_type"  = "Linux"
  "sku_name" = "Y1"
}

indentity = {
  "type" = "SystemAssigned"
}

pythonconfig = {
  "python_version" = "3.11"
  "python_runtime" = "python"
}

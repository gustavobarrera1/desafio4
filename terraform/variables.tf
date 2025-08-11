variable "subs-id" {
  type = string
}

variable "numeros" {
  description = "Map del resource group"
  type        = map(number)
}

variable "storageaccount" {
  description = "Map del storage account"
  type        = map(string)
}

variable "storagecontainer" {
  description = "Map del storage container"
  type        = map(string)
}

variable "servicesplan" {
  description = "Map del services plan"
  type        = map(string)
}

variable "indentity" {
  description = "Map del indentity"
  type        = map(string)
}

variable "pythonconfig" {
  description = "Map de la version y configuracion de python"
  type        = map(string)
}
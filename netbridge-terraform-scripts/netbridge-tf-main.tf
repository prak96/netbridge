#################

#   "${local.my_tags.project}"    =   "netBridge"
#   "${local.my_tags.usedBy}"    =   "tf"

#################



# Resource Group
resource "azurerm_resource_group" "my_rg" {
  location = "east asia"
  name     = "${local.my_tags.project}-${local.my_tags.usedBy}-rg"
  tags = merge(local.my_tags, {
    "service" = "resourceGroup"
  })
}


resource "azurerm_virtual_network" "my_vnet" {
  location            = azurerm_resource_group.my_rg.location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-vnet"
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = [var.vnet-cidr]

  tags = merge(local.my_tags, {
    "service" = "virtualNetwork"
  })
}


resource "azurerm_subnet" "adminSubnet" {
  # count = 1

  name                 = "subnet-admin"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = [cidrsubnet(var.vnet-cidr, 8, 0)]
}



#################

#   "${local.my_tags.project}"    =   "netBridge"
#   "${local.my_tags.usedBy}"    =   "tf"

#################


# Resource Group
resource "azurerm_resource_group" "my_rg" {
  location = var.rg_location
  name     = "${local.my_tags.project}-${local.my_tags.usedBy}-rg"
  tags = merge(local.my_tags, {
    "service" = "resourceGroup"
  })
}

###############################

## Azure Resources Environment ##

# Virtual Network For Resources
resource "azurerm_virtual_network" "my_vnet1" {
  location            = azurerm_resource_group.my_rg.location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-vnetResources"
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = [var.vnet1-cidr]

  tags = merge(local.my_tags, {
    "service" = "virtualNetwork-Resources"
  })
}



# Subnets
resource "azurerm_subnet" "subnet" {
  count = length(var.env_names)

  name                 = "${local.my_tags.usedBy}-${var.env_names[count.index]}-subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet1.name
  address_prefixes     = [cidrsubnet(var.vnet1-cidr, 8, count.index)]

  # depends_on = [ azurerm_network_security_group.nsg ]
}


# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  count = length(var.env_names)

  location            = azurerm_resource_group.my_rg.location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-${var.env_names[count.index]}-nsg"
  resource_group_name = azurerm_resource_group.my_rg.name

  tags = merge(local.my_tags, {
    "service" = "networkSecurityGroup"
  })
}
# NSG Association with Subnets!
resource "azurerm_subnet_network_security_group_association" "associateSubnetNSG" {
  count = length(var.env_names)

  network_security_group_id = azurerm_network_security_group.nsg[count.index].id

  subnet_id = azurerm_subnet.subnet[count.index].id

}


# Route Table
resource "azurerm_route_table" "routeTable" {
  location            = azurerm_resource_group.my_rg.location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-routeTable"
  resource_group_name = azurerm_resource_group.my_rg.name
  tags = merge(local.my_tags, {
    "service" = "routeTable"
  })
}



###############################

## VPN Configurations ##

## Virtual Network For VPN
resource "azurerm_virtual_network" "my_vnet2" {
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-vnetVPN"
  location            = var.vpn_location
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = [var.vnet2-cidr]

  tags = merge(local.my_tags,{
    "service" = "virtualNetwork-VPN"
  })

}

# resource "azurerm_bastion_host" "bastion" {
#   location = azurerm_virtual_network.my_vnet2.location
#   name = "${local.my_tags.project}-${local.my_tags.usedBy}-bastion"
#   resource_group_name = azurerm_resource_group.my_rg.name
  
# }


resource "azurerm_local_network_gateway" "localGateway" {
  location = azurerm_resource_group.my_rg.location
  name = "${local.my_tags.project}-${local.my_tags.usedBy}-localGateway"
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space = ["10.0.0.0/24", "192.168.0.0/24"]
  gateway_address = ""
  
}




## VPN Configurations ##

# Virtual Network For VPN
resource "azurerm_virtual_network" "my_vnet2" {
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-vnetVPN"
  location            = var.vpn_location
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = [var.vnet2-cidr]

  tags = merge(local.my_tags, {
    "service" = "virtualNetwork-VPN"
  })

}



# Gateway Subnet for VPN
resource "azurerm_subnet" "gatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet2.name
  address_prefixes     = [cidrsubnet(var.vnet2-cidr, 11, 0)]

}


# Subnet for Azure Bastion
resource "azurerm_subnet" "bastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet2.name
  address_prefixes     = [cidrsubnet(var.vnet2-cidr, 10, 8)]
}




# Azure Bastion
resource "azurerm_bastion_host" "bastion" {
  location            = azurerm_virtual_network.my_vnet2.location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-bastion"
  resource_group_name = azurerm_resource_group.my_rg.name
  ip_configuration {
    name                 = "default"
    public_ip_address_id = azurerm_public_ip.BASTIONpublicIP.id
    subnet_id            = azurerm_subnet.bastionSubnet.id
  }
  sku = "Standard"

  tags = merge(local.my_tags, {
    "service" = "azureBastion"
  })
}




# Local Network Gateway
resource "azurerm_local_network_gateway" "localGateway" {
  location            = var.vpn_location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-localGateway"
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = ["10.0.0.0/24"]
  gateway_address     = trimspace(data.http.my_publicIP.response_body)

  tags = merge(local.my_tags, {
    "service" = "localGateway"
  })
}


# Public IP ADDRESS for VPN
resource "azurerm_public_ip" "VPNpublicIP" {
  allocation_method   = "Static"
  location            = var.vpn_location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-VPNpublicIP"
  resource_group_name = azurerm_resource_group.my_rg.name
  sku_tier            = "Regional"
  sku                 = "Standard"

  tags = merge(local.my_tags, {
    "service" = "publicIP-vpn"
  })
}



# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "virtualGateway" {
  location            = var.vpn_location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-virtualGateway"
  resource_group_name = azurerm_resource_group.my_rg.name
  sku                 = "VpnGw2AZ"
  type                = "Vpn"
  vpn_type            = "RouteBased"
  ip_configuration {
    subnet_id                     = azurerm_subnet.gatewaySubnet.id
    name                          = "default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.VPNpublicIP.id
  }

  tags = merge(local.my_tags, {
    "service" = "virtualGateway"
  })
}


## S2S VPN Connections
resource "azurerm_virtual_network_gateway_connection" "vpnConnections" {
  location                   = var.vpn_location
  name                       = "${local.my_tags.project}-${local.my_tags.usedBy}-vpnConnection"
  resource_group_name        = azurerm_resource_group.my_rg.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.virtualGateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.localGateway.id
  connection_protocol        = "IKEv2"
  authorization_key          = var.vpn_connections_key

  tags = merge(local.my_tags, {
    "service" = "S2S-Connections"
  })
}


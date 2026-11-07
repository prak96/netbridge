


output "win-vm-ip" {
  description = "VM private IPs"
  value       = azurerm_network_interface.win-vm-nic.private_ip_address
}


output "subnet_cidrs" {
  description = "List of Subnet CIDRs"
  value = [
    for i, sbn in azurerm_subnet.subnet :
    {
      subnet_name = sbn.name
      subnet_cidr = sbn.address_prefixes

      nsg_name = azurerm_network_security_group.nsg[i].name
    }
  ]
}

output "gateway_subnet_cidr" {
  description = "My VPN Gateway Subnet"
  value       = azurerm_subnet.gatewaySubnet.address_prefixes
}

output "bastion_subnet_cidr" {
  description = "My Bastion Subnet"
  value = azurerm_subnet.bastionSubnet.address_prefixes
}

output "host_public_ip" {
  description = "Public IP address detected from the Terraform host"
  value       = trimspace(data.http.my_publicIP.response_body)
}

output "vpn_public_ip" {
  description = "Public IP address used in VPN"
  value       = azurerm_public_ip.VPNpublicIP.ip_address
}

output "bastion_public_ip" {
  description = "Public IP address used in Bastion"
  value       = azurerm_public_ip.BASTIONpublicIP.ip_address
}
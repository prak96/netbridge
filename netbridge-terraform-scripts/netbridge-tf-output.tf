


output "win-vm-ip" {
  description = "VM private IPs"
  value = azurerm_network_interface.win-vm-nic.private_ip_address
}

output "subnet_cidrs" {
    description = "List of Subnet CIDRs"
    value = [
        for i,sbn in azurerm_subnet.subnet:
        {
            subnet_name = sbn.name
            subnet_cidr = sbn.address_prefixes

            nsg_name = azurerm_network_security_group.nsg[i].name
        } 
    ]
}
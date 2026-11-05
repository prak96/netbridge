
### Azure Instance - Windows


# Azure VM NIC
resource "azurerm_network_interface" "win-vm-nic" {
    location = azurerm_resource_group.my_rg.location
    name = "${local.my_tags.project}-winvm-nic"
    resource_group_name = azurerm_resource_group.my_rg.name

    ip_configuration {
        name = "internal"
        private_ip_address_allocation = "Static"
        subnet_id = azurerm_subnet.subnet[0].id
        private_ip_address = cidrhost(azurerm_subnet.subnet[0].address_prefixes[0], 8)
    }
    
    tags = merge(local.my_tags, {
        "Name" = "networkInterface"
    })
}


# Azure VM
resource "azurerm_windows_virtual_machine" "win-vm" {
    location = azurerm_resource_group.my_rg.location
    name = "${local.my_tags.project}-winVM"
    network_interface_ids = [ azurerm_network_interface.win-vm-nic.id ]
    resource_group_name = azurerm_resource_group.my_rg.name

    size = "Standard_D2s_v6"
    admin_username = "${local.my_tags.project}-winVM"
    admin_password = var.win-password

    os_disk {
        name = "netBridge-Windows-OSdisk"
        caching = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
        disk_size_gb = var.osDisk

    }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2022-datacenter-g2"
    version = "latest"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }

  tags = merge(local.my_tags,{
    "service" = "virtualMachine"
    "os" = "winServer2022"
  })


}
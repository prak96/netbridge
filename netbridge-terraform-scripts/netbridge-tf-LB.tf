
### Azure LOAD BALANCER Configurations


# Azure LOAD BALANCER
resource "azurerm_lb" "LB" {
  count = length(var.env_names)

  location            = azurerm_resource_group.my_rg.location
  name                = "${local.my_tags.project}-${local.my_tags.usedBy}-LB"
  resource_group_name = azurerm_resource_group.my_rg.name
  sku = "Standard"
  sku_tier = "Regional"
  
  frontend_ip_configuration {
    name = "internal-frontend"
    subnet_id = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
  
  tags = merge(local.my_tags, {
    "service" = "loadBalancer"
  })
}


# Azure Load Balancer Backend POOL
resource "azurerm_lb_backend_address_pool" "LBpool" {
    loadbalancer_id = azurerm_lb.LB.id
    name = "${local.my_tags.project}-${local.my_tags.usedBy}-LBpool"    
}

# Azure Load Balancer PROBE
resource "azurerm_lb_probe" "LBprobe" {
    loadbalancer_id = azurerm_lb.LB.id
    name = "${local.my_tags.project}-${local.my_tags.usedBy}-LBprobe"
    
    port = 80
    protocol = "Tcp"
    
}

# Azure Load Balancing RULE
resource "azurerm_lb_rule" "httpRule" {
    backend_port = 80
    frontend_ip_configuration_name = "internal_frontend"
    frontend_port = 80
    loadbalancer_id = azurerm_lb.LB.id
    name = "${local.my_tags.project}-${local.my_tags.usedBy}-LBrule"
    protocol = "Tcp"
    probe_id = azurerm_lb_probe.LBprobe.id
    disable_outbound_snat = true
}

# # VM association with LB Backend Pool
# resource "azurerm_network_interface_backend_address_pool_association" "VMassociate" {
#     backend_address_pool_id = azurerm_lb_backend_address_pool.LBpool.id
#     ip_configuration_name = "internal"
#     network_interface_id = 
    
# }
# Declare prefix
variable "prefix" {
  default = "devops"
}

# create resource group in us 
resource "azurerm_resource_group" "rg_us" {
  name = "${var.prefix}-rg-us"
  location = "east us"

}

# create resource group in eu 
resource "azurerm_resource_group" "rg_eu" {
  name = "${var.prefix}-rg-eu"
  location = "Norway East"

}

# create network for us servers
resource "azurerm_virtual_network" "main_network_us" {
  name                = "${var.prefix}-main_network_us"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_us.location
  resource_group_name = azurerm_resource_group.rg_us.name
}

# create network for us servers
resource "azurerm_virtual_network" "main_network_eu" {
  name                = "${var.prefix}-main_network_eu"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_eu.location
  resource_group_name = azurerm_resource_group.rg_eu.name
}

# create subnet in us network
resource "azurerm_subnet" "internal_subnet_us" {
  name                 = "internal_subnet_us"
  resource_group_name  = azurerm_resource_group.rg_us.name
  virtual_network_name = azurerm_virtual_network.main_network_us.name
  address_prefixes     = ["10.0.2.0/24"]
}

# create subnet in us network
resource "azurerm_subnet" "internal_subnet_eu" {
  name                 = "internal_subnet_eu"
  resource_group_name  = azurerm_resource_group.rg_eu.name
  virtual_network_name = azurerm_virtual_network.main_network_eu.name
  address_prefixes     = ["10.1.2.0/24"]
}

# Create network adapter for first server in us subnet
resource "azurerm_network_interface" "us_server01_netadapter01" {
  name                = "${var.prefix}-nic-us_server01"
  location            = azurerm_resource_group.rg_us.location
  resource_group_name = azurerm_resource_group.rg_us.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal_subnet_us.id
    private_ip_address_allocation = "Dynamic"
  }
}

# create first server in us subnet
resource "azurerm_virtual_machine" "us_server01" {
  name                  = "${var.prefix}-us_server01"
  location              = azurerm_resource_group.rg_us.location
  resource_group_name   = azurerm_resource_group.rg_us.name
  network_interface_ids = [azurerm_network_interface.us_server01_netadapter01.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "us_server01_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "us01"
    admin_username = "admin-test"
    admin_password = "testing1212!@"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "devops_task"
    Owner = "shlomo"
  }
}

# Create network adapter for second server in us subnet
resource "azurerm_network_interface" "us_server02_netadapter01" {
  name                = "${var.prefix}-nic-us_server02"
  location            = azurerm_resource_group.rg_us.location
  resource_group_name = azurerm_resource_group.rg_us.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal_subnet_us.id
    private_ip_address_allocation = "Dynamic"
  }
}

# create second server in us subnet
resource "azurerm_virtual_machine" "us_server02" {
  name                  = "${var.prefix}-us_server02"
  location              = azurerm_resource_group.rg_us.location
  resource_group_name   = azurerm_resource_group.rg_us.name
  network_interface_ids = [azurerm_network_interface.us_server02_netadapter01.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "us_server02_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "us02"
    admin_username = "admin-test"
    admin_password = "testing1212!@"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "devops_task"
    Owner = "shlomo"
  }
}

# Create network adapter for first server in eu subnet
resource "azurerm_network_interface" "eu_server01_netadapter01" {
  name                = "${var.prefix}-nic-eu_server01"
  location            = azurerm_resource_group.rg_eu.location
  resource_group_name = azurerm_resource_group.rg_eu.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal_subnet_eu.id
    private_ip_address_allocation = "Dynamic"
  }
}

# create first server in eu subnet
resource "azurerm_virtual_machine" "eu_server01" {
  name                  = "${var.prefix}-eu_server01"
  location              = azurerm_resource_group.rg_eu.location
  resource_group_name   = azurerm_resource_group.rg_eu.name
  network_interface_ids = [azurerm_network_interface.eu_server01_netadapter01.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "eu_server01_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "us02"
    admin_username = "admin-test"
    admin_password = "testing1212!@"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "devops_task"
    Owner = "shlomo"
  }
}

# Create network adapter for second server in eu subnet
resource "azurerm_network_interface" "eu_server02_netadapter01" {
  name                = "${var.prefix}-nic-eu_server02"
  location            = azurerm_resource_group.rg_eu.location
  resource_group_name = azurerm_resource_group.rg_eu.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal_subnet_eu.id
    private_ip_address_allocation = "Dynamic"
  }
}

# create first server in eu subnet
resource "azurerm_virtual_machine" "eu_server02" {
  name                  = "${var.prefix}-eu_server02"
  location              = azurerm_resource_group.rg_eu.location
  resource_group_name   = azurerm_resource_group.rg_eu.name
  network_interface_ids = [azurerm_network_interface.eu_server02_netadapter01.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "eu_server02_osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "us02"
    admin_username = "admin-test"
    admin_password = "testing1212!@"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "devops_task"
    Owner = "shlomo"
  }
}

# Create public ip for us load balancer
resource "azurerm_public_ip" "us_public_ip" {
  name                = "us_public_ip"
  resource_group_name = azurerm_resource_group.rg_us.name
  location            = azurerm_resource_group.rg_us.location
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = "shalit"

    tags = {
        environment = "devops_task"
        Owner = "shlomo"
    }
  }

# Create load balancer in us subnet
resource "azurerm_lb" "us_lb" {
  name                = "us-lb"
  location            = azurerm_resource_group.rg_us.location
  resource_group_name = azurerm_resource_group.rg_us.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "frontend_ip_us"
    public_ip_address_id = azurerm_public_ip.us_public_ip.id
  }

    depends_on = [
      azurerm_public_ip.us_public_ip
    ]
  
}

# Create backend pool
resource "azurerm_lb_backend_address_pool" "us_backend_pool" {
  loadbalancer_id = azurerm_lb.us_lb.id
  name            = "us-backend-pool"

    depends_on = [
      azurerm_lb.us_lb
    ]

}

# add us_server01 ip address to backend pool
resource "azurerm_lb_backend_address_pool_address" "us_server01_address" {
  name                    = "us-server01-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.us_backend_pool.id
  virtual_network_id      = azurerm_virtual_network.main_network_us.id
  ip_address              = azurerm_network_interface.us_server01_netadapter01.private_ip_address
}

# add us_server02 ip address to backend pool
resource "azurerm_lb_backend_address_pool_address" "us_server02_address" {
  name                    = "us-server02-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.us_backend_pool.id
  virtual_network_id      = azurerm_virtual_network.main_network_us.id
  ip_address              = azurerm_network_interface.us_server02_netadapter01.private_ip_address
}

# Create us health prob
resource "azurerm_lb_probe" "us_lb_prob01" {
  loadbalancer_id = azurerm_lb.us_lb.id
  name            = "us-lb-prob01"
  port            = 80

  depends_on = [
    azurerm_lb.us_lb
  ]
}

# Create us lb rule
resource "azurerm_lb_rule" "us_lb_rule01" {
  loadbalancer_id                = azurerm_lb.us_lb.id
  name                           = "us-lb-rule01"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend_ip_us"
  probe_id = azurerm_lb_probe.us_lb_prob01.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.us_backend_pool.id]

  depends_on = [
    azurerm_lb.us_lb,
    azurerm_lb_probe.us_lb_prob01
  ]
}


# Create public ip for eu load balancer
resource "azurerm_public_ip" "eu_public_ip" {
  name                = "eu_public_ip"
  resource_group_name = azurerm_resource_group.rg_eu.name
  location            = azurerm_resource_group.rg_eu.location
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = "shalit"

    tags = {
        environment = "devops_task"
        Owner = "shlomo"
    }
  }

# Create load balancer in eu subnet
resource "azurerm_lb" "eu_lb" {
  name                = "eu-lb"
  location            = azurerm_resource_group.rg_eu.location
  resource_group_name = azurerm_resource_group.rg_eu.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "frontend_ip_eu"
    public_ip_address_id = azurerm_public_ip.eu_public_ip.id
  }

    depends_on = [
      azurerm_public_ip.eu_public_ip
    ]
  
}

# Create backend pool for eu lb
resource "azurerm_lb_backend_address_pool" "eu_backend_pool" {
  loadbalancer_id = azurerm_lb.eu_lb.id
  name            = "eu-backend-pool"

    depends_on = [
      azurerm_lb.eu_lb
    ]

}

# add eu_server01 ip address to backend pool
resource "azurerm_lb_backend_address_pool_address" "eu_server01_address" {
  name                    = "eu-server01-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.eu_backend_pool.id
  virtual_network_id      = azurerm_virtual_network.main_network_eu.id
  ip_address              = azurerm_network_interface.eu_server01_netadapter01.private_ip_address
}

# add eu_server02 ip address to backend pool
resource "azurerm_lb_backend_address_pool_address" "eu_server02_address" {
  name                    = "eu-server02-address"
  backend_address_pool_id = azurerm_lb_backend_address_pool.eu_backend_pool.id
  virtual_network_id      = azurerm_virtual_network.main_network_eu.id
  ip_address              = azurerm_network_interface.eu_server02_netadapter01.private_ip_address
}

# create eu health probe
resource "azurerm_lb_probe" "eu_lb_prob01" {
  loadbalancer_id = azurerm_lb.eu_lb.id
  name            = "eu-lb-prob01"
  port            = 80

  depends_on = [
    azurerm_lb.eu_lb
  ]
}

# Create eu lb rule
resource "azurerm_lb_rule" "eu_lb_rule01" {
  loadbalancer_id                = azurerm_lb.eu_lb.id
  name                           = "eu-lb-rule01"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend_ip_eu"
  probe_id = azurerm_lb_probe.eu_lb_prob01.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.eu_backend_pool.id]

  depends_on = [
    azurerm_lb.eu_lb,
    azurerm_lb_probe.eu_lb_prob01
  ]
}

# Create azure traffic manager profile
resource "azurerm_traffic_manager_profile" "trafficmanager01" {
  name                   = "shalittrafficmanager01"
  resource_group_name    = azurerm_resource_group.rg_us.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "shalittrafficmanager01"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/" 
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "devops"
  }
}

# create traffic manager endpoint for us
resource "azurerm_traffic_manager_azure_endpoint" "tm_us_endpoint" {
  name               = "tm_us_endpoint"
  profile_id         = azurerm_traffic_manager_profile.trafficmanager01.id
  weight             = 100
  target_resource_id = azurerm_public_ip.us_public_ip.id
}

# create traffic manager endpoint for eu
resource "azurerm_traffic_manager_azure_endpoint" "tm_eu_endpoint" {
  name               = "tm_eu_endpoint"
  profile_id         = azurerm_traffic_manager_profile.trafficmanager01.id
  weight             = 100
  target_resource_id = azurerm_public_ip.eu_public_ip.id
}
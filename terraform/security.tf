#App Gateway Network Security Group
resource "azurerm_network_security_group" "appgw_nsg" {
  name                = "appgw-nsg"
  location            = azurerm_resource_group.three_tier.location
  resource_group_name = azurerm_resource_group.three_tier.name

  security_rule {
    name                       = "Allow-Gateway-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Internet-HTTP-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-AzureLoadBalancer-Inbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Staging"
  }
}

#Web Subnet Network Security Group
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-nsg"
  location            = azurerm_resource_group.three_tier.location
  resource_group_name = azurerm_resource_group.three_tier.name

  security_rule {
    name                         = "Allow-AppGateway-HTTP-Inbound"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "80"
    source_address_prefix        = azurerm_subnet.appgw.address_prefixes[0]
    destination_address_prefix   = "*"
  }

  tags = {
    environment = "Staging"
  }
}

#App Subnet Network Security Group
resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.three_tier.location
  resource_group_name = azurerm_resource_group.three_tier.name

  security_rule {
    name                        = "Allow-Web-Inbound"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8080"
    source_address_prefix       = azurerm_subnet.web.address_prefixes[0]
    destination_address_prefix  = "*"
  }

  tags = {
    environment = "Staging"
  }
}

#DB Subnet Network Security Group
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = azurerm_resource_group.three_tier.location
  resource_group_name = azurerm_resource_group.three_tier.name

  security_rule {
    name                        = "Allow-App-Postgres-Inbound"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5432"
    source_address_prefix       = azurerm_subnet.app.address_prefixes[0]
    destination_address_prefix  = "*"
  }

  tags = {
    environment = "Staging"
  }
}

#App GW association
resource "azurerm_subnet_network_security_group_association" "appgw" {
  subnet_id                 = azurerm_subnet.appgw.id
  network_security_group_id = azurerm_network_security_group.appgw_nsg.id
}

#Web Subnet association
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

#App Subnet association
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

#DB Subnet association
resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}



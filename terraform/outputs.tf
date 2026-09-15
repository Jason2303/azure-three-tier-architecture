#Resource Group
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.three_tier.name
}

#Virtual Network
output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

#Subnets
output "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.appgw.id
}

output "web_subnet_id" {
  description = "ID of the web tier subnet"
  value       = azurerm_subnet.web.id
}

output "app_subnet_id" {
  description = "ID of the app tier subnet"
  value       = azurerm_subnet.app.id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db.id
}

#Application Gateway
output "appgw_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.gw_ip.ip_address
}

output "appgw_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.network.id
}

output "waf_policy_id" {
  description = "ID of the WAF policy attached to the Application Gateway"
  value       = azurerm_web_application_firewall_policy.waf.id
}

#NSGs
output "appgw_nsg_id" {
  description = "ID of the Application Gateway subnet NSG"
  value       = azurerm_network_security_group.appgw_nsg.id
}

output "web_nsg_id" {
  description = "ID of the web subnet NSG"
  value       = azurerm_network_security_group.web_nsg.id
}

output "app_nsg_id" {
  description = "ID of the app subnet NSG"
  value       = azurerm_network_security_group.app_nsg.id
}

output "db_nsg_id" {
  description = "ID of the database subnet NSG"
  value       = azurerm_network_security_group.db_nsg.id
}

#PostgreSQL Flexible Server
output "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.postgres.name
}

output "postgres_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_admin_username" {
  description = "Administrator username for the PostgreSQL Flexible Server"
  value       = var.postgres_admin_username
  sensitive   = true
}
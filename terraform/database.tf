#Private DNS Zone for PostgreSQL Flexible Server
resource "azurerm_private_dns_zone" "postgres" {
  name                = "three-tier.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.three_tier.name
}

#Link the Private DNS Zone to the VNet
resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-dns-link"
  private_dns_zone_id   = azurerm_private_dns_zone.postgres.id
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

#PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "three-tier-postgres"
  resource_group_name = azurerm_resource_group.three_tier.name
  location            = azurerm_resource_group.three_tier.location

  delegated_subnet_id   = azurerm_subnet.db.id
  private_dns_zone_id   = azurerm_private_dns_zone.postgres.id

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  sku_name   = "GP_Standard_D2s_v3"
  storage_mb = 32768
  version    = "16"

  zone = "1"

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled         = true
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
}


#Needed for tenant_id lookups
data "azurerm_client_config" "current" {}

#Managed identity representing the future app tier
resource "azurerm_user_assigned_identity" "app_identity" {
  name                = "app-tier-identity"
  resource_group_name = azurerm_resource_group.three_tier.name
  location            = azurerm_resource_group.three_tier.location
}

#Register the app identity as an AAD administrator on the server
resource "azurerm_postgresql_flexible_server_active_directory_administrator" "app" {
  server_name         = azurerm_postgresql_flexible_server.postgres.name
  resource_group_name = azurerm_resource_group.three_tier.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = azurerm_user_assigned_identity.app_identity.principal_id
  principal_name      = azurerm_user_assigned_identity.app_identity.name
  principal_type      = "ServicePrincipal"

  depends_on = [azurerm_postgresql_flexible_server.postgres]
}
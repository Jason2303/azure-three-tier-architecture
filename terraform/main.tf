# Create a resource group
resource "azurerm_resource_group" "three_tier" {
  name     = var.name
  location = var.region

  tags = {
    name = "Resource Group"
    environment = "Staging"
  }
}
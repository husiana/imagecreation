# Main VNET
data "azurerm_virtual_network" "mvnet" {
  count                = local.create_vnet ? 0 : 1
  name                 = local.virtual_network_name
  resource_group_name  = local.resource_group
}

resource "azurerm_virtual_network" "mvnet" {
  count               = local.create_vnet ? 1 : 0
  name                = local.virtual_network_name
  location            = local.create_vnet ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  resource_group_name = local.create_vnet ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  address_space       = [local.virtual_network_vnet_range]
}

# Frontend Subnet
data "azurerm_subnet" "frontend" {
  count                = local.create_admin_subnet ? 0 : 1
  name                 = local.virtual_network_subnet_name
  resource_group_name  = local.create_admin_subnet ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  virtual_network_name = local.virtual_network_name
}

resource "azurerm_subnet" "frontend" {
  count                = local.create_admin_subnet ? 1 : 0
  name                 = local.virtual_network_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.create_admin_subnet ? azurerm_virtual_network.mvnet[count.index].resource_group_name : data.azurerm_virtual_network.mvnet[count.index].resource_group_name
  address_prefixes     = [local.virtual_network_subnet_range]
}

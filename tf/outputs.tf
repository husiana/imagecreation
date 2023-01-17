resource "local_file" "packer_pip" {
  content = templatefile("${local.packer_root_dir}/templates/options.json.tmpl",
    {
      subscription_id = data.azurerm_subscription.primary.subscription_id
      resource_group  = local.resource_group
      location        = local.location
      sig_name        = azurerm_shared_image_gallery.sig.name
      private_virtual_network_with_public_ip = false # Never use public IPs for packer VMs
      virtual_network_name                   = local.create_vnet 
      virtual_network_subnet_name            = local.create_admin_subnet
      virtual_network_resource_group_name    = local.resource_group
    }
  )
  filename = "${local.packer_root_dir}/options.json"
}
locals {
    # azure environment
    azure_environment = var.AzureEnvironment
    tenant_id = var.tenant_id
    logged_user_objectId = var.logged_user_objectId
    
    # Load parameters from the configuration file
    configuration_file="${path.cwd}/config.yml"
    configuration_yml=yamldecode(file(local.configuration_file))
    admin_username=local.configuration_yml["admin_user"]
    location = local.configuration_yml["location"]
    resource_group = local.configuration_yml["resource_group"]
    
    virtual_network_name = local.configuration_yml["virtual_network_name"]
    virtual_network_vnet_range = local.configuration_yml["virtual_network_vnet_range"]
    virtual_network_subnet_name = local.configuration_yml["virtual_network_subnet_name"]
    virtual_network_subnet_range = local.configuration_yml["virtual_network_subnet_range"]

    extra_tags = try(local.configuration_yml["tags"], null)
    packer_root_dir = "${path.cwd}/packer"
    common_tags = {
        CreatedBy = var.CreatedBy
        CreatedOn = timestamp()
    }

    # Use a linux custom image reference if the linux_base_image is defined and contains ":"
    use_linux_image_reference = try(length(split(":", local.configuration_yml["linux_base_image"])[1])>0, false)

    # RedHat:RHEL:8-LVM:8.6.2022102701 
    linux_base_image_reference = {
        publisher = local.use_linux_image_reference ? split(":", local.configuration_yml["linux_base_image"])[0] : "RedHat"
        offer     = local.use_linux_image_reference ? split(":", local.configuration_yml["linux_base_image"])[1] : "RHEL"
        sku       = local.use_linux_image_reference ? split(":", local.configuration_yml["linux_base_image"])[2] : "8-LVM"
        version   = local.use_linux_image_reference ? split(":", local.configuration_yml["linux_base_image"])[3] : "8.6.2022102701"
    }

    # Use a linux custom image id if the linux_base_image is defined and contains "/"
    use_linux_image_id = try(length(split("/", local.configuration_yml["linux_base_image"])[1])>0, false)
    linux_image_id = local.use_linux_image_id ? local.configuration_yml["linux_base_image"] : null

    _empty_image_plan = {}
    _linux_base_image_plan = {
        publisher = try(split(":", local.configuration_yml["linux_base_plan"])[0], "")
        product   = try(split(":", local.configuration_yml["linux_base_plan"])[1], "")
        name      = try(split(":", local.configuration_yml["linux_base_plan"])[2], "")
    }
    linux_image_plan = try( length(local._linux_base_image_plan.publisher) > 0 ? local._linux_base_image_plan : local._empty_image_plan, local._empty_image_plan)

    # Create the RG
    use_existing_rg = try(local.configuration_yml["use_existing_rg"], false)
    create_rg = !local.use_existing_rg ? true : false

    # VNET
    create_vnet = try(length(local.vnet_id) > 0 ? false : true, true)
    vnet_id = try(local.configuration_yml["network"]["vnet"]["id"], null)
    create_admin_subnet    = try(local.configuration_yml["network"]["vnet"]["subnets"]["admin"]["create"], local.create_vnet )

}

variable AzureEnvironment {
  default = "AZUREPUBLICCLOUD"
}

variable CreatedBy {
  default = ""
}

variable tenant_id {
  type = string
  description = "The azure tenant id the user is logged in"
  default = ""
}

variable logged_user_objectId {
  type = string
  description = "The azure user logged object id"
  default = ""
}
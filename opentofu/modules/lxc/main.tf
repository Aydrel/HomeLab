resource "proxmox_virtual_environment_container" "this" {
  description = "Managed by Opentofu"

  node_name = var.node_name
  vm_id     = var.vm_id

  tags = var.tags

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

  memory {
    dedicated = var.memory
    swap      = var.memory_swap
  }

  cpu {
    cores = var.cpu
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    user_account {
      keys     = var.ssh_public_keys
      password = random_password.this.result
    }
  }


  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      name     = network_interface.value.name
      bridge   = network_interface.value.bridge
      firewall = network_interface.value.firewall
      vlan_id = network_interface.value.vlan_id
    }
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "debian"
  }

  features {
    nesting = true
  }

  dynamic "mount_point" {
    for_each = var.mount_points
    content {
      volume = mount_point.value["volume"]
      path   = mount_point.value["path"]
    }
  }

}

resource "random_password" "this" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.hostname
  description = "Managed by Terraform"
  tags        = var.tags

  node_name = var.node_name
  vm_id     = var.vm_id

  agent {
    enabled = var.qemu_agent
  }

  dynamic "clone" {
    for_each = var.clone_id != null ? [1] : []
    content {
      vm_id = var.clone_id
      full = var.full_clone
    }
  }

  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = var.cpu
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = var.memory
    floating = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = var.file_id
    size         = var.disk_size
    interface    = "scsi0"
  }

  initialization {

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    user_account {
      keys = var.ssh_public_keys
      username = var.username
    }
  }

  dynamic "network_device" {
    for_each = var.network_interfaces
    content {
      bridge   = network_device.value.bridge
      firewall = network_device.value.firewall
      vlan_id = network_device.value.vlan_id
    }
  }

  serial_device {}

  operating_system {
    type = "l26"
  }
}

locals {
  ssh_public_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjjbJIg44LvJIJFoh2jFNPeYI8dwevojaopDCiSyLbFUBADTbHPVoCXT62oF4Z+V+9FuYudgLqFkXSxRdrHxrsQClWoZwikT/oowB0tmhQyUQEgk8fsz8cM3GBWhdTS35Rh3CgoBASmeJYuKdsfWzWRRpJl93V1iOUJh5AIwUkBK+xTx7QJcgWIxh2FdyBqUgQfSEEPLnZygMD9UX5LPxI5VROZcpgmryKECxvLX2HCHhaBAtIZ2IiAMPuScAjXnTgAkT3FgcCQRzCBk0ewX41BomBzoIG6QL7ag+mguSLqaCv9INLhL5WZ2E/9Xcm2s5nYf2i5jV8IB5UJZ57ZnFAYRGYVsLSMvRnGrcmlcBce/IPfLoaVixUAoogsbA7iVVprFwxp/6v+rqyNfxUmRp1pZoUNc52hfuWDYDbtGffG/sAqhHaKSsHL+peSYfwBpnhrSo4EFNMhpHRnS7DRrU98SbgHEY2z+cPK9AtYHZwJPAb909LLWiRXY7CLriQbD8= root@DESKTOP-VL2A6HC"
  ]
}
resource "proxmox_virtual_environment_container" "twingate" {
  description = "Managed by OpenTofu"
  node_name = "pve"
  vm_id     = 111

  initialization {
    hostname = "twingate"

    ip_config {
      ipv4 {
        address = "192.168.1.111/24"
	gateway = "192.168.1.254"
      }
    }

    user_account {
      keys = local.ssh_public_keys
      password = random_password.debian_container_password.result
    }
  }

  network_interface {
    name = "eth0"
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  cpu {
    cores = 2
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
    # Or you can use a volume ID, as obtained from a "pvesm list <storage>"
    # template_file_id = "local:vztmpl/jammy-server-cloudimg-amd64.tar.gz"
    type             = "debian"
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  features {
    nesting = true
  }
}

resource "random_password" "debian_container_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "null_resource" "wait_for" {
  depends_on = [proxmox_virtual_environment_container.twingate]

  connection {
    host = "192.168.1.111"
    private_key = file("~/.ssh/id_rsa.pub")
  }

  provisioner "remote-exec" {
    inline = ["echo 'connected'"]
  }
}

resource "null_resource" "ansible" {
  depends_on = [null_resource.wait_for]

  provisioner "local-exec" {
    command = "cd ../../../ansible && ansible-playbook -i inventory.yml playbook.yml -uroot"
  }
}

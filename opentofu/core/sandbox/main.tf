module "vm_sandbox_debian12" {
  source = "../../modules/virtual_machines/"


  vm_id	= 120
  node_name = "pve" 
  file_id = "local:iso/debian-12-generic-amd64.img"

  hostname = "vm_sandbox_debian12"
  username = "aydrel"
  # Networking
  ipv4_gateway = "192.168.1.254"
  ipv4_address = "192.168.1.120/24"
  ssh_public_keys = [
    file("~/.ssh/id_rsa.pub")
  ]
  memory       = 2048
  cpu          = 2
  disk_size    = 10
}

resource "null_resource" "wait_for" {
  depends_on = [module.vm_sandbox_debian12]

  connection {
    host = "192.168.1.120"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = ["echo 'connected'"]
  }
}

resource "null_resource" "update_vm" {
  depends_on = [null_resource.wait_for]

  connection {
    host = "192.168.1.120"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = ["apt update -y && apt upgrade -y"]
  }
}

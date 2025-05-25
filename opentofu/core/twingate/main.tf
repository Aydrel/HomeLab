module "twingate" {
  source = "../../modules/lxc/"

  template_file_id = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"

  vm_id	= 111
  node_name = "pve" 

  hostname = "twingate"

  # Networking
  ipv4_gateway = "192.168.1.254"
  ipv4_address = "192.168.1.111/24"
  ssh_public_keys = [
    file("~/.ssh/id_rsa.pub")
  ]
  memory       = 1024
  memory_swap  = 512
  cpu          = 2
  disk_size    = 8
}

resource "null_resource" "wait_for" {
  depends_on = [module.twingate]

  connection {
    host = "192.168.1.111"
    private_key = file("~/.ssh/id_rsa")
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

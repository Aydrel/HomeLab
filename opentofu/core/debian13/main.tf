module "virtual_machine" {
  source = "../../modules/proxmox/virtual_machine"

  node_name = "pve"
  file_id   = "local:iso/debian-13-generic-amd64.img"

  hostname     = "aydrel-web-01"
  vm_id        = 150
  ipv4_address = "192.168.1.150/24"
  ipv4_gateway = "192.168.1.254"
  ssh_public_keys = [
    file("~/.ssh/id_rsa.pub")
  ]
  tags      = ["apache2", "virtual_machine", "linux"]
  username  = "aydrel"
  memory    = 4096
  cpu       = 2
  disk_size = 50
}

# resource "null_resource" "wait_for" {
#   depends_on = [module.virtual_machine]
# 
#   connection {
#     host        = "192.168.1.150"
#     user        = "aydrel"
#     private_key = file("~/.ssh/id_rsa.pub")
#   }
# 
#   provisioner "remote-exec" {
#     inline = ["echo 'connected'"]
#   }
# }
# 
# resource "null_resource" "ansible" {
#  depends_on = [null_resource.wait_for]
#
#  provisioner "local-exec" {
#    command = "source ../../../.env && cd ../../../ansible && ansible-playbook -i inventory.proxmox.yml playbooks/gitlab.yaml --become"
#  }
#}
#

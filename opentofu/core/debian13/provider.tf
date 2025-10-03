provider "proxmox" {
  endpoint = var.proxmox_endpoint

  username = var.proxmox_username
  password = var.proxmox_password

  insecure = true
  tmp_dir  = "/var/tmp"

  ssh {
    agent = true
    # username = "root"
  }
}

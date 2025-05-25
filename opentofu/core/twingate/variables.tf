variable "pm_password" {
  description = "Mot de passe Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_user" {
  type    = string
  default = "root@pam"
}

variable "pm_endpoint" {
  type    = string
}

variable "pm_node" {
  type    = string
  default = "pve"
}

variable "pm_storage" {
  type    = string
  default = "local-lvm"
}

variable "template" {
  type    = string
  default = "local:vztmpl/ubuntu-22.04-standard_20240107_amd64.tar.zst"
}


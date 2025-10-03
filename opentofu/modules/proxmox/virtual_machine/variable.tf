variable "mount_points" {
  type = list(object({
    volume = string
    path   = string
  }))
  default = []
}

variable "username" {
  type = string
}

variable "file_id" {
  type = string
}

variable "network_interfaces" {
  type = list(object({
    bridge   = string
    firewall = bool
    vlan_id  = number
  }))

  default = [{
    bridge   = "vmbr0"
    firewall = true
    vlan_id  = null
  }]
}
variable "tags" {
  type    = list(string)
  default = []
}

variable "ssh_public_keys" {
  type = list(string)
}

variable "node_name" {
  type = string
}

variable "datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "hostname" {
  type = string
}

variable "vm_id" {
  type    = number
  default = 100
}

variable "ipv4_address" {
  type = string
}

variable "ipv4_gateway" {
  type = string
}

variable "disk_size" {
  type    = number
  default = 4
}

variable "memory" {
  type    = number
  default = 512
}

variable "cpu" {
  type    = number
  default = 1
}

variable "tier" {
  type    = string
  default = "small"
}

variable "tiers" {
  description = "Settings for container tiers"
  type = map(object({
    cpu    = number
    memory = number
    disk   = number
  }))
  default = {
    small = {
      cpu    = 1
      memory = 512
      disk   = 5
    }
    medium = {
      cpu    = 2
      memory = 1024
      disk   = 10
    }
    large = {
      cpu    = 4
      memory = 2048
      disk   = 20
    }
  }
}

variable "clone_id" {
  type = number
  default = null
}

variable "full_clone" {
  type = bool
  default = true
}

variable "qemu_agent" {
  type = bool
  default = false
}

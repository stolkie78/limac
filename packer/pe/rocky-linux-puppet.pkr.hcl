packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/proxmox"
        }
    }
}

variable "proxmox_url"{
  default = "https://192.168.1.124:8006/api2/json"
}

variable "proxmox_username"{
  default = "terraform-prov@pve"
}

variable "proxmox_password"{
  default = "welkom"
}

variable "template_name"{
  default = "rocky-linux-puppet"
}

variable "puppet_install_url"{
  default = "https://pm.puppet.com/cgi-bin/download.cgi?ver=8&dist=el&arch=x86_64"
}

source "proxmox-clone" "pe" {
  clone_vm                 = "template-rocky9"
  cores                    = 1
  insecure_skip_tls_verify = true
  memory                   = 2048
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  scsi_controller      = "virtio-scsi-single"
  node                 = "proxmox01"
  os                   = "l26"
  password             = "${var.proxmox_password}"
  pool                 = "terraform-pool"
  proxmox_url          = "${var.proxmox_url}"
  sockets              = 1
  cpu_type             = "x86-64-v2-AES"
  ssh_username         = "root"
  ssh_password         = "root"
  ssh_pty              = true
  template_description = "image made from cloud-init image"
  template_name        = "template-rocky9"
  username             = "${var.proxmox_username}"
  ipconfig {
    ip = "192.168.1.75/24"
    gateway = "192.168.1.1"
  }
  nameserver = "192.168.1.1"
}

build {
  sources = ["source.proxmox-clone.pe"]

  provisioner "shell" {
    inline = [
      "yum update -y",
      "curl -o /tmp/puppet-enterprise-installer.tar.gz https://pm.puppet.com/cgi-bin/download.cgi?ver=8&dist=el&arch=x86_64",
      "tar -xzf /tmp/puppet-enterprise-installer.tar.gz -C /tmp",
      "cd /tmp/puppet-enterprise-*",
      "./puppet-enterprise-installer"
    ]
  }

  provisioner "shell" {
    inline = [
      "puppet --version",
      "echo 'Puppet Enterprise installation complete!'"
    ]
  }
}
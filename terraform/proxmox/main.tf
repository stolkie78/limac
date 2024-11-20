terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
 pm_api_url   = "https://192.168.1.124:8006/api2/json"
 pm_user      = "terraform-prov@pve"
 pm_password  = "welkom"
 #pm_api_token_id = "root@pam!terraform"
 #pm_api_token_secret = "96ae667e-3768-4365-a101-18d47120d6d5"
 pm_tls_insecure = true
}

#resource "proxmox_pool" "terraform-pool" {
#  poolid  = "terraform-pool" 
#}
#variable "vm_count" {
#  description = "Het aantal machines dat moet worden aangemaakt."
#  default     = 3
#}
#
#resource "proxmox_vm_qemu" "test_vm" {
#  count       = var.vm_count
#  name        = "vm-${count.index + 1}"  # Voeg een volgnummer toe aan de VM-naam
#  target_node = "proxmox01"                   # Naam van de Proxmox node
#  clone       = "template-rocky9"             # Naam van de bestaande VM die je wilt klonen
#  sockets     = 1
#  cores       = 1
#  memory      = 2048                          # Geheugen in MB
#  pool        = "terraform-pool"
#  scsihw      = "virtio-scsi-single"
#  
#  disk {
#    slot    = "scsi0"
#    type    = "disk"
#    storage = "local-lvm"                     # Opslag, gebruik local-lvm
#    size    = "32G"                           # Schijfgrootte
#  }

  #provisioner "remote-exec" {
  #  inline = ["sudo hostnamectl set-hostname test-vm-${count.index + 1}.example.com"]
  #}
#}

variable "lxc_count" {
  description = "Het aantal LXC-containers dat moet worden aangemaakt."
  default     = 3
}

resource "proxmox_lxc" "ubuntu_container" {
  count       = var.lxc_count
  hostname    = "ubuntu-container-${count.index + 1}"  # Voeg een volgnummer toe aan de containernaam
  target_node = "proxmox01"                             # Naam van de Proxmox node
  template    = "ubuntu-template"                        # Naam van de bestaande LXC-template die je wilt klonen
  password    = "strongpassword"                         # Stel een sterk wachtwoord in voor de container
  cores       = 1                                        # Aantal CPU-cores
  memory      = 2048                                     # Geheugen in MB
  swap        = 512                                      # Optioneel: hoeveelheid swapgeheugen
  #net0        = "name=eth0,bridge=vmbr0,ip=dhcp"       # Netwerkinstellingen
  #storage     = "local-lxc"                             # Opslag, gebruik local-lxc
  
  # Optioneel: Voeg hier extra configuratie toe als nodig
  # zoals schijfconfiguratie of specifieke resource-instellingen
}
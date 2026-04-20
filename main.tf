terraform {
  required_providers {
    # Configuration du provider GitHub
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    # Configuration du provider Docker
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}
provider "docker" {
  host = "tcp://192.168.146.130:2375" # Remplacez par votre IP
}

# --- Configuration GITHUB ---
provider "github" {
  token = var.github_token
}

variable "github_token" {
  description = "Token pour GitHub"
  type        = string
  sensitive   = true
}

# --- Configuration DOCKER ---
# On laisse vide pour que Terraform choisisse automatiquement
# le bon protocole (Unix pour Linux/Pipeline ou npipe pour Windows)
provider "docker" {}

# --- Ressources KALI ---
resource "docker_image" "kali" {
  name         = "kalilinux/kali-rolling"
  keep_locally = false
}

resource "docker_container" "kali_container" {
  image      = docker_image.kali.image_id
  name       = "mon-kali-docker"
  stdin_open = true
  tty        = true
}

# --- Ressources UBUNTU ---
resource "docker_image" "ubuntu" {
  name         = "ubuntu:latest"
  keep_locally = false
}

resource "docker_container" "ubuntu_target" {
  image      = docker_image.ubuntu.image_id
  name       = "mon_ubuntu_terraform"
  stdin_open = true
  tty        = true

  ports {
    internal = 22
    external = 2222
  }
}

terraform {
  required_providers {
    github = { source = "integrations/github"; version = "~> 6.0" }
    docker = { source = "kreuzwerker/docker"; version = "~> 3.0.1" }
    # Ajout de VMware vSphere
    vsphere = { source = "hashicorp/vsphere"; version = "~> 2.4.0" }
  }
}

# --- Configuration WINDOWS SERVER 2019 (VMware) ---

resource "vsphere_virtual_machine" "win_server" {
  name             = "Mon-Windows-Server-2019"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = "windows9Server64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 40
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    
    # Personnalisation de Windows (Nom, Mot de passe admin, etc.)
    customize {
      windows_options {
        computer_name = "win-srv-2019"
        admin_password = "TonMotDePasseSecurise123!"
      }
    }
  }
}




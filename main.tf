terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
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
# On laisse vide pour la détection automatique locale
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

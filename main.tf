terraform {
  required_providers {
    # On garde le provider GitHub
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    # On ajoute le provider Docker
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
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
provider "docker" {
  host = "npipe:////./pipe/docker_engine" # Indispensable pour Windows
}

resource "docker_image" "kali" {
  name = "kalilinux/kali-rolling"
}

resource "docker_container" "kali_container" {
  image = docker_image.kali.image_id
  name  = "mon-kali-docker"
  stdin_open = true
  tty        = true
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "ubuntu" {
  name         = "ubuntu:latest"
  keep_locally = false
}

resource "docker_container" "ubuntu_target" {
  image = docker_image.ubuntu.image_id
  name  = "mon_ubuntu_terraform"
  
  # Pour qu'il reste allumé et qu'on puisse se connecter
  stdin_open = true
  tty        = true
  
  ports {
    internal = 22
    external = 2222
  }
}


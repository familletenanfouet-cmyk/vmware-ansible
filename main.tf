# Déclaration de la variable (on ne met pas la valeur ici)
variable "github_token" {
  type      = string
  sensitive = true
}

provider "github" {
  token = var.github_token
}

# C'est ce bloc qui va réellement créer le repository sur GitHub
resource "github_repository" "vmware-ansible" {
  name        = "vmcluster"
  description = "Mon superbe projet géré par Terraform"
  visibility  = "public"
  auto_init   = true # Crée automatiquement le README.md
}

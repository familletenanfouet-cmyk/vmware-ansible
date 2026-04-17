# Déclaration de la variable (on ne met pas la valeur ici)
variable "github_token" {
  type      = string
  sensitive = true
}

provider "github" {
  token = var.github_token
}

provider "aws" {}

locals {
  root-folder = "./resources"
}

module "network" {
  source = "${local.root-folder}/vpc"
  stack-name = var.stack-name

  personal-ip = var.personal-ip
  bastion-key = var.bastion-key
  db-password = var.db-password
  db-username = var.db-username
}

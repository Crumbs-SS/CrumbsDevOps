provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./resources/network"
  stack-name = "crumbs"
  personal_ip = "${var.personal_ip}"
  bastion-key = "${var.bastion_key}"
  db-password = "${var.db_password}"
  db-username = "${var.db_username}"
}

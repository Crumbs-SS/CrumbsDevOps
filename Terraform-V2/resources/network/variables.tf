
variable "personal_ip" {
  type = string
}
variable "bastion-key" {
  type = string
}

variable "db-password" {
  description = "Password for MySql database access"
  type = string
}

variable "db-username" {
  description = "Username for MySql database access"
  type = string
}

variable "stack-name" {
  type = string
}

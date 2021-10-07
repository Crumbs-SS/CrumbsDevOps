output "ssh-command" {
    description = "Run this command in your terminal to ssh into bastion instance."
    value = network.ssh-command
}

output "bastion-host-ip" {
  description = "Public Ip of Bastion Host"
  value = network.bastion-host-ip
}

output "database-endpoint" {
    description = "The database endpoint"
    value = network.database-endpoint
}
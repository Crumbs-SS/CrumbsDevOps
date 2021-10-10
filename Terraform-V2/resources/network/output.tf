output "ssh-command" {
    description = "Run this command in your terminal to ssh into bastion instance."
    value = "ssh -i ${var.bastion-key}.pem ec2-user@${aws_instance.bastion-instance.public_dns}"
}

output "bastion-host-ip" {
  description = "Public Ip of Bastion Host"
  value = aws_instance.bastion-instance.public_dns
}

output "database-endpoint" {
    description = "The database endpoint"
    value = aws_db_instance.relation-db.address
}

output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "alb" {
  value = aws_lb.alb
}
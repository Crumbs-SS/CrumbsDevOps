output "alb_dns" {
    value = module.ecs_cluster.lb_dns_name
}

# resource "aws_secretsmanager_secret" "alb_dns" {
#     name = "alb_dns"
# }

# resource "aws_secretsmanager_secret_version" "alb_dns_version" {
#     secret_id = aws_secretsmanager_secret.alb_dns.id
#     secret_string = module.ecs_cluster.lb_dns_name
# }
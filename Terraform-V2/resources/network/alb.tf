

resource "aws_secretsmanager_secret" "alb-dns-name" {
  name = "dev/crumbs/alb/dns"
}

resource "aws_secretsmanager_secret" "alb-arn" {
  name = "dev/crumbs/alb/arn"
}

resource "aws_secretsmanager_secret_version" "alb-arn-version" {
  secret_id = aws_secretsmanager_secret.alb-arn.id
  secret_string = aws_lb.alb.arn
}

resource "aws_secretsmanager_secret_version" "alb-dns-name-version" {
  secret_id     = aws_secretsmanager_secret.alb-dns-name.id
  secret_string = aws_lb.alb.dns_name
}

resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  load_balancer_type = "application"
  subnets            = aws_subnet.public-subnets.*.id
  security_groups    = [aws_security_group.alb-sg.id]
  ip_address_type    = "ipv4"
}
output "ecs_execution_role" {
    value = aws_iam_role.ecs_execution_role.arn
}

output "alb_arn" {
    value = aws_lb.ecs_lb.arn
}

output "ecs_cluster" {
    value = aws_ecs_cluster.ecs_cluster.id
}

output "lb_listener_arn" {
    value = aws_lb_listener.alb_listener.arn
}

output "lb_dns_name" {
    value = aws_lb.ecs_lb.dns_name
}

output "lb_security_groups" {
    value = [aws_security_group.alb_sg.id]
}
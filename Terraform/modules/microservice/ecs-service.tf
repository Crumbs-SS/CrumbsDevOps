resource "aws_ecs_service" "service" {
    name = var.service_name
    cluster = var.ecs_cluster
    task_definition = aws_ecs_task_definition.task_definition.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = var.private_subnets
        security_groups = var.lb_security_groups
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.target_group.arn
        container_name = var.service_name
        container_port = var.container_port
    }
}
resource "aws_ecs_service" "service" {
    name = var.service_name
    cluster = var.ecs_cluster
    task_definition = aws_ecs_task_definition.task_definition.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = var.public_subnets
        security_groups = var.lb_security_groups
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.target_group.arn
        container_name = var.service_name
        container_port = var.container_port
    }
}

# resource "aws_ecs_service" "account_service" {
#     name = "account_service"
#     cluster = aws_ecs_cluster.ecs_cluster.id
#     task_definition = aws_ecs_task_definition.account_service_task_definition.id
#     desired_count = 1
#     launch_type = "FARGATE"

#     network_configuration {
#         subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
#         security_groups = [aws_security_group.alb_sg.id]
#         assign_public_ip = true
#     }

#     load_balancer {
#         target_group_arn = aws_lb_target_group.account_target_group.arn
#         container_name = "accountservice"
#         container_port = 8080
#     }
# }

# resource "aws_ecs_service" "restaurant_service" {
#     name = "restaurant_service"
#     cluster = aws_ecs_cluster.ecs_cluster.id
#     task_definition = aws_ecs_task_definition.restaurant_service_task_definition.id
#     desired_count = 1
#     launch_type = "FARGATE"

#     network_configuration {
#         subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
#         security_groups = [aws_security_group.alb_sg.id]
#         assign_public_ip = true
#     }

#     load_balancer {
#         target_group_arn = aws_lb_target_group.restaurant_target_group.arn
#         container_name = "restaurantservice"
#         container_port = 8080
#     }
# }
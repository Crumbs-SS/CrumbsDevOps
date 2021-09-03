resource "aws_ecs_task_definition" "task_definition" {
    family = var.service_name
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    execution_role_arn = var.ecs_execution_role
    container_definitions = jsonencode([
        {
            name = var.service_name
            image = var.ecr_repository
            portMappings = [
                {
                    containerPort = var.container_port
                }
            ]
        }
    ])
}

# resource "aws_ecs_task_definition" "account_service_task_definition" {
#     family = "account_service_task_definition"
#     network_mode = "awsvpc"
#     requires_compatibilities = ["FARGATE"]
#     cpu = 256
#     memory = 512
#     execution_role_arn = aws_iam_role.ecs_execution_role.arn
#     container_definitions = jsonencode([
#         {
#             name = "accountservice"
#             image = "728482858339.dkr.ecr.us-east-1.amazonaws.com/accountservice"
#             portMappings = [
#                 {
#                     containerPort = 8080
#                 }
#             ]
#         }
#     ])
# }

# resource "aws_ecs_task_definition" "restaurant_service_task_definition" {
#     family = "restaurant_service_task_definition"
#     network_mode = "awsvpc"
#     requires_compatibilities = ["FARGATE"]
#     cpu = 256
#     memory = 512
#     execution_role_arn = aws_iam_role.ecs_execution_role.arn
#     container_definitions = jsonencode([
#         {
#             name = "restaurantservice"
#             image = "728482858339.dkr.ecr.us-east-1.amazonaws.com/restaurantservice"
#             portMappings = [
#                 {
#                     containerPort = 8080
#                 }
#             ]
#         }
#     ])
# }
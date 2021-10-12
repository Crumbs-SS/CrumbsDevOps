resource "aws_ecs_task_definition" "task_definition" {
    family = var.service_name
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = var.cpu
    memory = var.memory
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
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = "us-east-1"
                    awslogs-create-group = "true"
                    awslogs-stream-prefix = "ecs"
                    awslogs-group = var.service_name
                }
            }
        }
    ])
}


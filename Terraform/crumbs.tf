module "vpc" {
    source = "./modules/vpc"

    vpc_cidr_block = "10.0.0.0/16"
    vpc_name = "Swift-Demo-VPC"
}

module "ecs_cluster" {
    source = "./modules/ecs-cluster"

    ecs_name = "Swift-Demo-ECS"

    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
}

module "account_service" {
    source = "./modules/microservice"

    service_name = "Swift-Demo-account-service"
    container_port = 8080
    listener_path = "/account-service/*"
    health_check_path = "/actuator/health"
    ecr_repository = "${var.aws_id}.dkr.ecr.us-east-1.amazonaws.com/accountservice:latest"
    cpu = 256
    memory = 512

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_arn = module.ecs_cluster.alb_arn
    alb_listener = module.ecs_cluster.lb_listener_arn
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}

module "order_service" {
    source = "./modules/microservice"

    service_name = "Swift-Demo-order-service"
    container_port = 8010
    listener_path = "/order-service/*"
    health_check_path = "/actuator/health"
    ecr_repository = "${var.aws_id}.dkr.ecr.us-east-1.amazonaws.com/orderservice:latest"
    cpu = 256
    memory = 512

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_arn = module.ecs_cluster.alb_arn
    alb_listener = module.ecs_cluster.lb_listener_arn
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}

module "restaurant_service" {
    source = "./modules/microservice"

    service_name = "Swift-Demo-restaurant-service"
    container_port = 8070
    listener_path = "/restaurant-service/*"
    health_check_path = "/actuator/health"
    ecr_repository = "${var.aws_id}.dkr.ecr.us-east-1.amazonaws.com/restaurantservice:latest"
    cpu = 256
    memory = 512

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_arn = module.ecs_cluster.alb_arn
    alb_listener = module.ecs_cluster.lb_listener_arn
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}

module "email_service" {
    source = "./modules/microservice"

    service_name = "Swift-Demo-email-service"
    container_port = 8090
    listener_path = "/email-service/*"
    health_check_path = "/actuator/health"
    ecr_repository = "${var.aws_id}.dkr.ecr.us-east-1.amazonaws.com/emailservice:latest"
    cpu = 256
    memory = 512

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_arn = module.ecs_cluster.alb_arn
    alb_listener = module.ecs_cluster.lb_listener_arn
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}

module "payment_service" {
    source = "./modules/microservice"

    service_name = "Swift-Demo-payment-service"
    container_port = 8100
    listener_path = "/payment-service/*"
    health_check_path = "/actuator/health"
    ecr_repository = "${var.aws_id}.dkr.ecr.us-east-1.amazonaws.com/paymentservice:latest"
    cpu = 256
    memory = 512

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_arn = module.ecs_cluster.alb_arn
    alb_listener = module.ecs_cluster.lb_listener_arn
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}
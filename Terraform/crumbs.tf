module "vpc" {
    source = "./modules/vpc"

    vpc_cidr_block = "10.0.0.0/16"
}

module "ecs_cluster" {
    source = "./modules/ecs-cluster"

    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
}

module "order_service" {
    source = "./modules/microservice"

    service_name = "order-service"
    container_port = 8080
    health_check_path = "/orders"
    listener_path = ["/orders/*"]
    ecr_repository = "728482858339.dkr.ecr.us-east-1.amazonaws.com/orderservice:latest"

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_listener = module.ecs_cluster.alb_listener
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}

module "account_service" {
    source = "./modules/microservice"

    service_name = "account-service"
    container_port = 8080
    health_check_path = "/login"
    listener_path = ["/*"]
    ecr_repository = "728482858339.dkr.ecr.us-east-1.amazonaws.com/accountservice:latest"

    vpc_id = module.vpc.vpc_id
    ecs_execution_role = module.ecs_cluster.ecs_execution_role
    alb_listener = module.ecs_cluster.alb_listener
    ecs_cluster = module.ecs_cluster.ecs_cluster
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    lb_security_groups = module.ecs_cluster.lb_security_groups

    depends_on = [
        module.vpc,
        module.ecs_cluster
    ]
}
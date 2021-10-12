variable "service_name" {
    type = string
    description = "Name of the service"
}

variable "container_port" {
    type = number
    description = "The port that the container exposes"
}

variable "listener_path" {
    type = string
    description = "Path for the load balancer listener"
}

variable "health_check_path" {
    type = string
    description = "Path for the target group's health checks"
}

variable "ecr_repository" {
    type = string
    description = "URL for the ecr repository to pull images from"
}

variable "memory" {
    type = number
    description = "How much memory to allocate for this microservice"
}

variable "cpu" {
    type = number
    description = "How much cpu to allocate for this microservice"
}

#Resources from other modules
variable "ecs_execution_role" {
    type = string
    description = "ARN of the ecs_execution_role to be assigned to the task definitions"
}

variable "vpc_id" {
    type = string
    description = "ID of the vpc being used"
}

variable "alb_arn" {
    type = string
    description = "ARN of the ALB"
}

variable "alb_listener" {
    type = string
    description = "ARN of the ALB Listener"
}

variable "ecs_cluster" {
    type = string
    description = "ID of the ECS Cluster to add the services to"
}

variable "public_subnets" {
    type = list(string)
    description = "List of public subnet ids"
}

variable "private_subnets" {
    type = list(string)
    description = "List of private subnet ids"
}

variable "lb_security_groups" {
    type = list(string)
    description = "List of alb security groups"
}
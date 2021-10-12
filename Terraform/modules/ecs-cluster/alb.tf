resource "aws_lb" "ecs_lb" {
    name = "ecs-lb"
    internal = false
    load_balancer_type = "application"
    subnets = var.public_subnets
    security_groups = [aws_security_group.alb_sg.id]

    tags = {
        Name = format("%s_%s", var.ecs_name, "alb")
    }
} 

resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.ecs_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.default_target_group.arn
    }
}

resource "aws_lb_target_group" "default_target_group" {
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id
}

resource "aws_security_group" "alb_sg" {
    name = "alb_sg"
    vpc_id = var.vpc_id

    ingress {
        description = "tcp 8080"
        from_port = 0
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "tcp 8060"
        from_port = 0
        to_port = 8010
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "tcp 8070"
        from_port = 0
        to_port = 8070
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "tcp 8080"
        from_port = 0
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "tcp 8090"
        from_port = 0
        to_port = 8090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "tcp 8100"
        from_port = 0
        to_port = 8100
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = format("%s_%s", var.ecs_name, "alb_sg")
    }
}
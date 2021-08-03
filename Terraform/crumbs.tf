resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = "vpc"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags = {
        Name = "public_subnet"    
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"

    tags = {
        Name = "public_subnet_2"    
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"

    tags = {
        Name = "private_subnet"    
    }
}

resource "aws_security_group" "public_ec2_security_group" {
    name = "public_ec2_security_group"
    description = "Allow SSH and HTTP to EC2 instance in public subnet"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
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
        Name = "public_ec2_security_group"
    }
}

resource "aws_security_group" "private_ec2_security_group" {
    name = "private_ec2_security_group"
    description = "Allow SSH, MySQL, and ICMP to private EC2 instance from the public subnet only"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    ingress {
        description = "MySQL"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    ingress {
        description = "MySQL"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "public_ec2_security_group"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "public_route_table"
    }
}

resource "aws_route_table_association" "public_rt_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rt_association_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id 
    }

    tags = {
        Name = "private_route_table"
    }
}

resource "aws_route_table_association" "private_rt_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public_subnet.id

    tags = {
        "Name" = "nat_gateway"
    }
}

resource "aws_eip" "eip" {
    vpc = true

    depends_on = [aws_internet_gateway.internet_gateway]
}

######################################################

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "ecs_cluster"

    tags = {
        "Name" = "ecs_cluster"
    }
}

resource "aws_iam_role" "ecs_execution_role" {
    name = "ecs_execution_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "smi-attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_ecs_task_definition" "order_service_task_definition" {
    family = "order_service_task_definition"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecs_execution_role.arn
    container_definitions = jsonencode([
        {
            name = "orderservice"
            image = "728482858339.dkr.ecr.us-east-1.amazonaws.com/orderservice"
            portMappings = [
                {
                    containerPort = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "account_service_task_definition" {
    family = "account_service_task_definition"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecs_execution_role.arn
    container_definitions = jsonencode([
        {
            name = "accountservice"
            image = "728482858339.dkr.ecr.us-east-1.amazonaws.com/accountservice"
            portMappings = [
                {
                    containerPort = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "restaurant_service_task_definition" {
    family = "restaurant_service_task_definition"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecs_execution_role.arn
    container_definitions = jsonencode([
        {
            name = "restaurantservice"
            image = "728482858339.dkr.ecr.us-east-1.amazonaws.com/restaurantservice"
            portMappings = [
                {
                    containerPort = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "order_service" {
    name = "order_service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.order_service_task_definition.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = [aws_subnet.private_subnet.id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.order_target_group.arn
        container_name = "orderservice"
        container_port = 8080
    }
}

resource "aws_ecs_service" "account_service" {
    name = "account_service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.account_service_task_definition.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = [aws_subnet.private_subnet.id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.account_target_group.arn
        container_name = "accountservice"
        container_port = 8080
    }
}

resource "aws_ecs_service" "restaurant_service" {
    name = "restaurant_service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.restaurant_service_task_definition.id
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = [aws_subnet.private_subnet.id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.restaurant_target_group.arn
        container_name = "restaurantservice"
        container_port = 8080
    }
}

resource "aws_lb_target_group" "order_target_group" {
    name = "order-target-group"
    port = 8080
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.vpc.id

    depends_on = [aws_lb.ecs_lb] 
}

resource "aws_lb_target_group" "account_target_group" {
    name = "account-target-group"
    port = 8080
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.vpc.id

    depends_on = [aws_lb.ecs_lb] 
}

resource "aws_lb_target_group" "restaurant_target_group" {
    name = "restaurant-target-group"
    port = 8080
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.vpc.id

    depends_on = [aws_lb.ecs_lb] 
}

resource "aws_lb_listener" "order_listener" {
    load_balancer_arn = aws_lb.ecs_lb.arn
    port = 8081
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.order_target_group.arn
    }
}

resource "aws_lb_listener" "account_listener" {
    load_balancer_arn = aws_lb.ecs_lb.arn
    port = 8082
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.account_target_group.arn
    }
}

resource "aws_lb_listener" "restaurant_listener" {
    load_balancer_arn = aws_lb.ecs_lb.arn
    port = 8083
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.restaurant_target_group.arn
    }
}

resource "aws_lb" "ecs_lb" {
    name = "ecs-lb"
    load_balancer_type = "application"
    subnets = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]

    tags = {
        Name = "ecs_lb"
    }
}

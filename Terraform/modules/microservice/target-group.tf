
resource "aws_lb_target_group" "target_group" {
    name = var.service_name
    port = var.container_port
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.vpc_id

    health_check {
      path = var.health_check_path
    }
}

# resource "aws_lb_target_group" "account_target_group" {
#     name = "account-target-group"
#     port = 8080
#     protocol = "HTTP"
#     target_type = "ip"
#     vpc_id = aws_vpc.vpc.id

#     health_check {
#       path = "/login"
#     }
# }

# resource "aws_lb_target_group" "restaurant_target_group" {
#     name = "restaurant-target-group"
#     port = 8080
#     protocol = "HTTP"
#     target_type = "ip"
#     vpc_id = aws_vpc.vpc.id

#     health_check {
#       path = "/restaurants"
#     }
# }
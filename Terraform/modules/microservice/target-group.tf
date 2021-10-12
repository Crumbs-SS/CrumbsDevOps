
resource "aws_lb_target_group" "target_group" {
    name = var.service_name
    port = var.container_port
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.vpc_id

    health_check {
      path = var.health_check_path
      healthy_threshold = 2
      interval = 120
    }
}
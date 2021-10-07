
resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  load_balancer_type = "application"
  subnets            = aws_subnet.public-subnets.*.id
  security_groups    = [aws_security_group.alb-sg.id]
  ip_address_type    = "ipv4"
}

resource "aws_lb_target_group" "default-target-group" {
  name        = "${var.stack-name}-default-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default-target-group.arn
  }
}
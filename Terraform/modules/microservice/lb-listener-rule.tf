resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = var.alb_listener
  
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = [var.listener_path]
    }
  }
}
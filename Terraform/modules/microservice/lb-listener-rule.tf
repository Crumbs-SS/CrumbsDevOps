resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = var.alb_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = var.listener_path
    }
  }
}

# resource "aws_lb_listener_rule" "account_listener_rule" {
#   listener_arn = aws_lb_listener.account_listener.arn
#   priority     = 101

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.account_target_group.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

# resource "aws_lb_listener_rule" "restaurant_listener_rule" {
#   listener_arn = aws_lb_listener.restaurant_listener.arn
#   priority     = 102

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.restaurant_target_group.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/restaurants/*"]
#     }
#   }
# }
#---- loadbalancing/main.tf ----#
resource "aws_lb" "mustafa_lb" {
  name            = "mustafa-loadbalancer"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400
}
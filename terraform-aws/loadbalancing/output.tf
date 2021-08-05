#--- loadbalancing/output.tf ----#
output "lb_target_group_arn" {
  value = "aws_lb_target_group.mustafa_tg.arn"
}
output "lb_endpoint" {
  value = "aws_lb.mustafa_lb.dns_name"
}
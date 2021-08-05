#--- compute/outputs.tf ---#

output "instance" {
  value     = aws_instance.mtc_node[*]
  sensitive = true
}

output "instance_port" {
  value = "aws_lb_target_group_attachment.mustafa_tg_attachment[0].port"
}
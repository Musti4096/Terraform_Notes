# ------ networking/outputs.tf -----#

output "vpc_id" {
  value = aws_vpc.mustafa_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnetgroup.*.name
}

output "db_security_group_ids" {
  value = [aws_security_group.mustafa_sg["rds"].id]
}
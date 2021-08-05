# ---- database/output.tf ----#

output "db_endpoint" {
  value = "aws_db_instance.mustafa_db.endpoint"
}
# ------ networking/outputs.tf -----#

output "vpc_id" {
    value = aws_vpc.mustafa_vpc.id
}
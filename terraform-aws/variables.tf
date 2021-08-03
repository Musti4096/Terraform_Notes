# --- root/variables.tf --- #
variable "aws_region" {
  default = "us-east-1"
}
variable "access_ip" {
  type = string
}

#---- database variables ----#

variable "dbname" {
  type        = string
  description = "DB name"
}

variable "dbusername" {
  type        = string
  description = "DB username"
  sensitive   = true
}

variable "dbpassword" {
  type        = string
  description = "database password"
  sensitive   = true
}
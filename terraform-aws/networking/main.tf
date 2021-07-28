####### Networking main.tf ##########

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "mustafa_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "mustafa-vpc-${random_integer.random.id}"
  }
}
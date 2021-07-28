####### Networking main.tf ##########

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "mustafa_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mustafa-vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "mustafa_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.mustafa_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]

  tags = {
    Name = "mustafa_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "mustafa_private_subnet" {
  count                   = length(var.private_cidrs)
  vpc_id                  = aws_vpc.mustafa_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false 
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]

  tags = {
    Name = "mustafa_private_subnet_${count.index + 1}"
  }
}
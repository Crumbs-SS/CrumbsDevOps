resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    "Name" = "${var.stack-name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.stack-name}-vpc-igw"
  }
}

resource "aws_eip" "natgwEIP" {
  tags = {
    "Name" = "${var.stack_name}-natgw-eip"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgwEIP.id
  subnet_id     = aws_subnet.public-subnets[1].id

  tags = {
    "Name" = "${var.stack_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

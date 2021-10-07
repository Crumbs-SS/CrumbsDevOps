resource "aws_subnet" "public-subnets" {
  count  = 2
  vpc_id = aws_vpc.vpc.id

  availability_zone       = count.index == 1 ? "us-east-1a" : "us-east-1b"
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.stack-name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = count.index == 1 ? "us-east-1a" : "us-east-1b"
  cidr_block              = "10.0.${count.index + 3}.0/24"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "${var.stack-name}-private-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "public-subnet-0-rt-association" {
  subnet_id = aws_subnet.public-subnets[0].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-1-rt-association" {
  subnet_id = aws_subnet.public-subnets[1].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-subnet-0-rt-association" {
  subnet_id = aws_subnet.private-subnets[0].id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-1-rt-association" {
  subnet_id = aws_subnet.private-subnets[1].id
  route_table_id = aws_route_table.private-route-table.id
}


resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  depends_on = [
    aws_internet_gateway.igw,
    aws_route_table.public-route-table
  ]
}

resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.natgw.id

  depends_on = [
    aws_nat_gateway.natgw,
    aws_route_table.private-route-table
  ]
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.stack-name}-public-rt"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.stack-name}-private-rt"
  }
  depends_on = [aws_nat_gateway.natgw]
}
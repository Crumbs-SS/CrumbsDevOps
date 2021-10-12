resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        "Name" = format("%s_%s", var.vpc_name, "internet_gateway")
    }
}

resource "aws_nat_gateway" "nat_gateway" {    
    allocation_id = aws_eip.nat_eip.id
    connectivity_type = "public"
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
        "Name" = format("%s_%s", var.vpc_name, "nat_gateway")
    }

    depends_on = [
      aws_eip.nat_eip
    ]
}

resource "aws_eip" "nat_eip" {
    vpc = true

    tags = {
        "Name" = format("%s_%s", var.vpc_name, "nat_eip")
    }
}
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        "Name" = "internet_gateway"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    connectivity_type = "private"
    subnet_id = aws_subnet.private_subnet_1.id   #variable?

    tags = {
        "Name" = "nat_gateway"
    }
}

# resource "aws_nat_gateway" "nat_gateway" {
#     connectivity_type = "private"
#     subnet_id = aws_subnet.private_subnet_1.id

#     tags = {
#         "Name" = "nat_gateway"
#     }
# }
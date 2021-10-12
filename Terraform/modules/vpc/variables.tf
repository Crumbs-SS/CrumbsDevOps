variable "vpc_cidr_block" {
    type = string
    description = "cidr block for the VPC to use"
}

variable "vpc_name" {
    type = string
    description = "Name for the VPC"
    default = "vpc"
}
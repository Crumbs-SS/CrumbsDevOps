variable "vpc_id" {
    type = string
    description = "ID of the vpc being used"
}

variable "public_subnets" {
    type = list(string)
    description = "List of the public subnet ids"
}

variable "private_subnets" {
    type = list(string)
    description = "List of the private subnet ids"
}
resource "aws_db_instance" "relation-db" {
    identifier = "${var.stack-name}-db"
    db_subnet_group_name = ""
    name = "${var.stack-name}-database"
    instance_class = "db.t2.micro"
    allocated_storage = "20"
    engine = "MySQL"
    engine_version = "8.0.16"
    username = var.db-username
    password = var.db-password

    vpc_security_group_ids = [ aws_security_group.database-sg.id ]
}

resource "aws_db_subnet_group" "private-subnet-group" {
  name = "${var.stack-name}-private-subnet-group"
  description = "Subnet group for private subnets"
  subnet_ids = aws_subnet.private-subnets.*.id
}
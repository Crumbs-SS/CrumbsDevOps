resource "aws_security_group" "alb-sg" {
  description = "Enable HTTP access on port 80"
  vpc_id      = aws_vpc.vpc.id

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow traffic from anywhere"
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]


  egress = [
    {
      description      = "Allows all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    "Name" = "${var.stack-name}-alb-sg"
  }
}

resource "aws_security_group" "bastion-sg" {
  description = "Enables SSH Access to Bastion Hosts"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      protocol         = "tcp"
      description      = "Enable SSH access from personal IP"
      from_port        = 22
      to_port          = 22
      cidr_blocks      = ["${var.personal_ip}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  egress = [
    {
      description      = "Allow all traffic"
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    "Name" = "${var.stack-name}-bastion-sg"
  }
}

resource "aws_security_group" "container-sg" {
  vpc_id      = aws_vpc.vpc.id
  description = "Enable all access from ALBSecurityGroup and Bastion"

  ingress = [{
    description      = "Enable all access from Bastion SG"
    from_port        = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion-sg.id]
    to_port          = 22
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
    },
    {
      description      = "Enable all access from ALB SG"
      from_port        = 0
      protocol      = "-1"
      security_groups  = [aws_security_group.alb-sg.id]
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      cidr_blocks      = []
  }]

  egress = [
    {
      description      = "Allows all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    "Name" = "${var.stack-name}-container-sg"
  }

}

resource "aws_security_group" "database-sg" {
  vpc_id      = aws_vpc.vpc.id
  description = "Enable all access from bastion and container security groups"

  ingress = [{
    description      = "Enable access from bastion and container sg"
    from_port        = 0
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion-sg.id, aws_security_group.container-sg.id]
    to_port          = 65525
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }]

  egress = [
    {
      description      = "Allows all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  tags = {
    "Name" = "${var.stack-name}-database-sg"
  }
}

resource "aws_instance" "bastion-instance" {
  instance_type          = "t2.micro"
  key_name               = var.bastion-key
  ami                    = "ami-02e136e904f3da870"
  subnet_id              = aws_subnet.public-subnets[1].id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  tags = {
    "Name" = "${var.stack-name}-bastion-host"
  }
}
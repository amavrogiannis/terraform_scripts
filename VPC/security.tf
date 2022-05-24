resource "aws_security_group" "ssh-enable" {
  vpc_id = aws_vpc.dev-vpc.id

  ingress = [{
    description      = "SG for the dev vpc"
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 22
    to_port          = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
  }]

  egress = [{
    description      = "outgound traffic - all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
}
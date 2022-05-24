resource "aws_security_group" "ssh-enable" {
  vpc_id = aws_vpc.dev-vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress = [{
    cidr_blocks = ["0.0.0.0/0"]
    #description = "value"
    from_port = 22
    #ipv6_cidr_blocks = [ "value" ]
    #prefix_list_ids = [ "value" ]
    protocol = "tcp"
    #security_groups = [ "value" ]
    #self = false
    #to_port = 1
  }]
  tags = var.resource_tags
}
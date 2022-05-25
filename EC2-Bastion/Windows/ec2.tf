data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.windows.id
  instance_type               = "t3.small"
  associate_public_ip_address = true
  key_name                    = "bastion-ec2"
  

  subnet_id = aws_subnet.public_subnet.id


  tags = {
    "Name" = "bastion"
  }

}
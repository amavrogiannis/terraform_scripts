# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm/ubuntu-precise-*.*-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]
# }

# resource "aws_launch_configuration" "ubuntu" {
#   name_prefix   = var.auto_scaling_group
#   image_id      = data.aws_ami.ubuntu.id
#   instance_type = var.instance_type

#   lifecycle {
#     create_before_destroy = true
#   }

# }
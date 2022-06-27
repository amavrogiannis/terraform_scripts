# resource "aws_placement_group" "eks-node" {
#   name     = "eks-node-group"
#   strategy = "cluster"
# }

# resource "aws_autoscaling_group" "eks-node" {
#   name                      = var.auto_scaling_group
#   max_size                  = var.AG_max_size
#   min_size                  = var.AG_min_size
#   health_check_grace_period = 300
#   health_check_type         = "ELB"
#   desired_capacity          = 1
#   force_delete              = true
#   placement_group           = aws_placement_group.eks-node.id
#   // launch_configuration = aws_launch_configuration.ubuntu.name
#   vpc_zone_identifier = [module.vpc.public_subnets[1], module.vpc.private_subnets[1]]
# #   launch_template {
# #     // id = aws_launch_template.eks-launch.id
# #     id      = module.eks.eks_managed_node_groups
# #     version = "$Latest"
# #   }

# }

# resource "aws_launch_template" "eks-launch" {
#   name_prefix   = var.eks_cluster_name
#   image_id      = data.aws_ami.ubuntu.id
#   instance_type = var.instance_type
# }
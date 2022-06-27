module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"
  # insert the 9 required variables here

  cluster_name                    = var.eks_cluster_name
  cluster_version                 = "1.21"
  subnet_ids                      = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2], module.vpc.public_subnets[3]]
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  

  # worker_groups = [
  #   {
  #     instance_type = "${var.instance_type}"
  #     asg_max_size  = 2
  #     asg_min_size = 1
  #     asg_desired_capacity = 1
  #     name = "${var.eks_cluster_name}.ASG-temp"
  #   }
  # ]

  self_managed_node_group_defaults = {
    instance_type                          = "${var.instance_type}"
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  eks_managed_node_group_defaults = {
    disk_size      = 10
    instance_types = ["${var.instance_type}"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["${var.instance_type}"]
      capacity_type  = "ON_DEMAND"
    }
  }

  depends_on = [module.vpc.id]

  # manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "${aws_iam_role.eks-nodegroup-NodeInstanceRole.arn}"
  #     username = "${var.iam_user}"
  #   },
  # ]

  # aws_auth_users = [
  #   {
  #     userarn  = "${data.aws_iam_user.account}"
  #     username = "${var.iam_user}"
  #   },
  # ]

  # aws_auth_accounts = [
  #   635779605500,
  # ]

}


# module "eks_managed_node_group" {
#   source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

#   name            = module.eks.cluster_id
#   cluster_name    = module.eks.cluster_id
#   cluster_version = "1.21"

#   subnet_ids = [module.vpc.public_subnets[0],module.vpc.public_subnets[1],module.vpc.public_subnets[2],module.vpc.public_subnets[3]]
#   vpc_id     = module.vpc.vpc_id

#   update_launch_template_default_version = true

#   min_size     = 1
#   max_size     = 2
#   desired_size = 1

#   instance_types = ["${var.instance_type}"]
#   capacity_type  = "ON_DEMAND"

#   create_iam_role = false
#   create_launch_template = true

#   iam_role_arn = aws_iam_role.eks-nodegroup-NodeInstanceRole.arn
#   //nodegroup_role_arn = aws_iam_role.eks-nodegroup-NodeInstanceRole.arn
#   // launch_template_name = aws_launch_template.eks-launch.id


#   security_group_name = module.vpc.default_vpc_default_security_group_id

#   depends_on = [
#     module.eks.id, 
#     module.vpc.id, 
#     aws_iam_role_policy_attachment.eks-nodegroup-attachment, 
#     aws_iam_role_policy_attachment.nodes-AWS_EC2ContainerRegistryRO
#     ]


# }
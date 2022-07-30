module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"
  # insert the 9 required variables here

  cluster_name                    = var.eks_cluster_name
  cluster_version                 = "1.22"
  subnet_ids                      = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2], module.vpc.public_subnets[3]]
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  #This is a mandatory selection, which you allow EKS cluster create it's own clusters using EC2 instance. 
  self_managed_node_group_defaults = {
    instance_type                          = "${var.instance_type}"
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  eks_managed_node_group_defaults = {
    disk_size      = 10 // Disk size is measured in GiB
    instance_types = ["${var.instance_type}"]
  }

  #EKS allocates the vallue of having max instances "2", where "1" is desired. The instance running mode, is set to ON_DEMAND, there is also "SPOT" option too. 
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

  depends_on = [module.vpc.id] // Important to demand EKS service to wait, once the VPC is created. 

}

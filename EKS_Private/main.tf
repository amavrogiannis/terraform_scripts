module "aws_network" {
  source = "./modules/vpc"

  create_vpc = var.create_vpc
  vpc_name   = var.vpc_name

  vpc_cidr = var.vpc_cidr

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress

  cidr_block_public_route = var.cidr_block_public_route

  allow_public_ip = var.allow_public_ip

  public_sub_cidr_block  = var.public_sub_cidr_block
  private_sub_cidr_block = var.private_sub_cidr_block

  private_subnet_tags = var.private_subnet_tags
}


resource "aws_security_group" "ep_vpc" {
  name        = "alexm-vpc-endpoints-"
  description = "VPC Endpoint SG"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  depends_on = [ module.aws_network ]
} 

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.1"

  vpc_id = data.aws_vpc.this.id

  // Assigning Security Group for EP
  security_group_ids = [aws_security_group.ep_vpc.id]

  endpoints = merge({
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = data.aws_route_table.this_private[*].id
      tags = {
        Name = "this-ep-s3"
      }
    }
    },
    {
      for service in toset(["autoscaling", "ecr.api", "ecr.dkr", "ec2", "ec2messages", "elasticloadbalancing", "sts", "kms", "logs", "ssm", "ssmmessages"]) :
      replace(service, ".", "_") =>
      {
        service             = service
        subnet_ids          = data.aws_subnet.private_subs[*].id
        private_dns_enabled = true
        tags = {
          Name = "this-${service}"
        }
      }
  })

  depends_on = [ module.aws_network, aws_security_group.ep_vpc ]
}



module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "alex-eks"
  cluster_version = "1.28"
  vpc_id          = data.aws_vpc.this.id

  create_iam_role = false

  iam_role_arn              = aws_iam_role.eks_policy.arn
  manage_aws_auth_configmap = false

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  # cluster_endpoint_public_access_cidrs = [
  #   "${data.http.myip}"
  # ]

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  subnet_ids = [
    data.aws_subnet.private_subs[0].id,
    data.aws_subnet.private_subs[1].id,
    data.aws_subnet.private_subs[2].id
  ]
  # control_plane_subnet_ids = [
  #   data.aws_subnet.private_subs[0].id,
  #   data.aws_subnet.private_subs[1].id,
  #   data.aws_subnet.public_subs[0].id
  # ]

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    capacity_type  = "SPOT"

    create_iam_role                       = false
    attach_cluster_primary_security_group = true

    iam_role_arn                           = "${aws_iam_role.this_node_role.arn}"
    update_launch_template_default_version = true

    vpc_security_group_ids = [data.aws_security_group.default_sg.id]

  }

  eks_managed_node_groups = {
    main = {
      name = "eks-managed-ng"

      desired_size = 1
      min_size     = 1
      max_size     = 5

      use_custom_launch_template = false

      disk_size = 60

      # remote_access = {
      #   ec2_ssh_key = "alex-m-test"
      # }
      labels = {
        Environment = "test"
        Contact     = "alex.mavrogiannis"
        Project     = "Alex_Test"
      }
    }
  }

  tags = {
    Environment                      = "dev"
    "kubernetes.io/cluster/alex-eks" = "owned"
  }

  depends_on = [module.aws_network]
}

# module "node_groups" {
#   source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

#   name            = "this_nodes"
#   cluster_name    = "alex-eks"

#   key_name = data.aws_key_pair.alex_kp

#   create_iam_role = false
#   iam_role_arn = aws_iam_role.this_node_role.arn

#   subnet_ids = [
#     data.aws_subnet.private_subs[0].id,
#     data.aws_subnet.private_subs[1].id,
#     data.aws_subnet.private_subs[2].id
#   ]

#   cluster_primary_security_group_id = module.eks_cluster.cluster_primary_security_group_id
#   vpc_security_group_ids = [data.aws_security_group.default_sg.id]

#   min_size     = 1
#   max_size     = 5
#   desired_size = 1

#   ami_type = "AL2_x86_64"
#   instance_types = ["t3.medium"]
#   capacity_type  = "SPOT"
#   cluster_ip_family = "ipv4"

#   create_launch_template = true
#   disk_size = 60

#   tags = {
#     Environment = "dev"
#     Terraform   = "TRUE"
#   }

#   labels = {
#     Environment = "test"
#     Contact = "alex.mavrogiannis"
#     Project = "Alex_Test"
#   }

#   depends_on = [ module.eks_cluster ]
# }
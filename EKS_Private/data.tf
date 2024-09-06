// GET my local IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

// DATA - VPC Security Group
data "aws_security_group" "default_sg" {
  filter {
    name   = "tag:Name"
    values = ["alex-test-default_sg"]
  }

  depends_on = [ module.aws_network ]
}

// DATA - VPC 
data "aws_vpc" "this" {
  filter {
    name   = "tag:Project"
    values = ["Alex_Test"]
  }

  depends_on = [ module.aws_network ]
}

//DATA - Availability Zones
data "aws_availability_zones" "this" {}

// DATA - AWS Private Subnets
data "aws_subnet" "private_subs" {
  count = length(data.aws_availability_zones.this.zone_ids)
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-vpc-private-sub-${count.index + 1}"]
  }

  depends_on = [ module.aws_network ]
}

// DATA - AWS Public Subnets
data "aws_subnet" "public_subs" {
  count = length(data.aws_availability_zones.this.names)
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-vpc-public-sub-${count.index + 1}"]
  }

  depends_on = [ module.aws_network ]
}

// DATA - Private Route Table
data "aws_route_table" "this_private" {
  count     = length(data.aws_availability_zones.this.zone_ids)
  subnet_id = data.aws_subnet.private_subs[count.index].id

  depends_on = [ module.aws_network ]
}

// EKS POLICY and ROLE
resource "aws_iam_role" "eks_policy" {
  name               = "alex-eks-test"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_policy-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_policy.name
}

resource "aws_iam_role_policy_attachment" "eks_policy-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_policy.name
}
// END EKS POLICY


// NODE GROUP ROLE - POLICY
resource "aws_iam_role" "this_node_role" {
  name               = "alex-eks-node-test"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "this_node_policy" {
  name   = "eks-node-group-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.this_node_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.this_node_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.this_node_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this_node_role.name
}

resource "aws_iam_role_policy_attachment" "this_node_policy_for_eks" {
  policy_arn = aws_iam_policy.this_node_policy.arn
  role       = aws_iam_role.this_node_role.name
}
// NODE GROUP ROLE - POLICY END

// KEY PAIR
# data "aws_key_pair" "alex_kp" {
#   filter {
#     name   = "tag:Contact"
#     values = ["alex.mavrogiannis"]
#   }
# }
# Pulling current iam user data, which is running the the AWS account.
data "aws_iam_user" "account" {
  user_name = var.iam_user
}

# Define output, which use is utilised to provision the infrastructure. 
output "iam_user" {
  value = data.aws_iam_user.account.user_name
}

# Allocating IAM Group, where permissions and policies will be allocated.
resource "aws_iam_group" "group" {
  name = "test-group"
  path = "/"
}

resource "aws_iam_group_membership" "group" {
  name  = aws_iam_group.group.name
  group = aws_iam_group.group.name

  users = [
    data.aws_iam_user.account.user_name
  ]
}

# Setting up the Role for EKS Cluster, followed by policy attachment, also role group attachment. 
resource "aws_iam_role" "eks-Cluster-role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "eks-fargate-pods.amazonaws.com",
              "eks.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "eks-cluster-Role"
  path                  = "/"
  tags = {
    "Name" = "eks-cluster/ServiceRole"

  }

}

output "cluster_service_roles_arn" {
  value = aws_iam_role.eks-Cluster-role.arn
}

resource "aws_iam_role_policy_attachment" "eks-cluster-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-Cluster-role.id

}

resource "aws_iam_group_policy_attachment" "eks-cluster-group-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_role_policy_attachment.eks-cluster-attachment.policy_arn
}

# Setting up the Role for Node group, followed by policy attachment, also role group attachment. 
resource "aws_iam_role" "eks-nodegroup-NodeInstanceRole" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "eks-nodegroup-NodeInstanceRole"
  path                  = "/"
  tags = {
    "Name" = "eks-nodegroup-NodeInstanceRole/NodeInstanceRole"
  }
}

output "nodegroup_role_arn" {
  value = aws_iam_role.eks-nodegroup-NodeInstanceRole.arn
}

resource "aws_iam_role_policy_attachment" "eks-nodegroup-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-nodegroup-NodeInstanceRole.id
}

resource "aws_iam_group_policy_attachment" "eks-node-group-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_role_policy_attachment.eks-nodegroup-attachment.policy_arn
}

# This policy attachment will allow the node group IAM Role, to access Read only to ECR for images. 
resource "aws_iam_role_policy_attachment" "nodes-AWS_EC2ContainerRegistryRO" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-nodegroup-NodeInstanceRole.name

}
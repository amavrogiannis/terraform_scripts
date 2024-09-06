resource "aws_iam_role" "ecs-deploy" {
  name = "this-ecs-test"
  managed_policy_arns = [
    data.aws_iam_policy.ecr.arn,
    data.aws_iam_policy.ecs-container.arn,
    data.aws_iam_policy.ecs-exec.arn,
    data.aws_iam_policy.ecs-full.arn
  ]
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

data "aws_iam_policy" "ecs-full" {
  name = "AmazonECS_FullAccess"
}

data "aws_iam_policy" "ecs-exec" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "ecs-container" {
  name = "AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy" "ecr" {
  name = "AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy_document" "assume-role" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "scheduler" {
  name = "alexm-ecs-exec"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
  ]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "scheduler-new" {
  name = "alexm-ecs-exec-new"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
  ]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "scheduler.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


resource "aws_ecs_cluster" "this" {
  name = "alexm"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family = "alexm-task"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 1024
  memory = 2048
  container_definitions = jsonencode([{
    name = "container-alex"
    image = "nginx:latest"
    essential = true
    portMappings = [
        {
            containerPort = 80
            hostPort = 80
        }
    ]
    environment = [
        { "name" : "OWNER", "value" : "ALEXM"}
    ]
  }])

}

    # logConfiguration = {
    #     logDriver = "awslogs"
    #     options = {
    #         awslogs-group = "ecs/${aws_ecs_cluster.this.name}/container-alex/"
    #         awslogs-region = "eu-west-1"
    #         awslogs-stream-prefix = "xyz"
    #     }
    # }

resource "aws_ecs_service" "this" {
  name = "service-${aws_ecs_task_definition.this.family}"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.this-ecs.id]
    subnets = [aws_subnet.public[0].id, aws_subnet.public[1].id]
    assign_public_ip = true
  }
}
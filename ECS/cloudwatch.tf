resource "aws_scheduler_schedule" "this" {
  name       = "alexm-schedule"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(30 * * * ? *)"

  target {
    arn      = aws_ecs_cluster.this.arn
    role_arn = aws_iam_role.scheduler-new.arn

    ecs_parameters {
      task_count = 1
      task_definition_arn = aws_ecs_task_definition.this.arn
      launch_type = aws_ecs_service.this.launch_type

      network_configuration {
        security_groups = [aws_security_group.this-ecs.id]
        subnets = [aws_subnet.public[0].id, aws_subnet.public[1].id]
        assign_public_ip = true
      }
    }
  }
}

# resource "aws_cloudwatch_event_rule" "this" {
#   name = "alexm-schedule"
#   schedule_expression = "cron(5 * * * ? *)"
# }

# resource "aws_cloudwatch_event_target" "this" {
#   target_id = aws_ecs_cluster.this.name
#   arn = aws_ecs_cluster.this.arn
#   rule = aws_cloudwatch_event_rule.this.name
#   role_arn = aws_iam_role.scheduler.arn

#   ecs_target {
#     task_count = 1
#     task_definition_arn = aws_ecs_task_definition.this.arn
#     launch_type = aws_ecs_service.this.launch_type

#     network_configuration {
#       security_groups = [aws_security_group.this-ecs.id]
#       subnets = [aws_subnet.public[0].id, aws_subnet.public[1].id]
#       assign_public_ip = true
#     }
#   }
# }
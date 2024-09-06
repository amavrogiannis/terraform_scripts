resource "aws_lambda_function" "lambda_function" {
  for_each = var.lambda_functions

  function_name = each.key
  handler       = each.value.handler
  runtime       = each.value.runtime
  filename      = data.archive_file.lambda[each.key].output_path
  role          = aws_iam_role.this.arn

    dynamic "environment" {
      # for_each = each.value.env_variables
      for_each = each.value.env_variables

      content {
        variables = try(each.value.env_variables, null)
      }
    }
#   environment {
#     variables = each.value.env_variables
#   }

  source_code_hash = data.archive_file.lambda[each.key].output_base64sha256

}

resource "aws_iam_role" "this" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

locals {
  now      = timestamp()
  date_utc = formatdate("YYYYMMDD-mmss", local.now)
  path = "./code"
  output = "./code/out"
}

data "archive_file" "lambda" {
  for_each = var.lambda_functions

  type        = "zip"
  output_path = join("/", [".", local.output, each.value.lambda_function_path, "${each.value.lambda_function_path}-${local.date_utc}.zip" ])
  source_dir  = join("/", [".", local.path, each.value.lambda_function_path ])
}

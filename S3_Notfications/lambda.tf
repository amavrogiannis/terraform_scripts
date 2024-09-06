data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::*"
}
resource "aws_lambda_permission" "allow_bucket1" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func1.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::*"
}

resource "aws_lambda_function" "func" {
  filename      = "./this.zip"
  function_name = "alex_test"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "this.example"
  runtime       = "python3.12"
}

resource "aws_lambda_function" "func1" {
  filename      = "./this.zip"
  function_name = "alex_test1"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "this1.example"
  runtime       = "python3.12"
}
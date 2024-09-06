s3_bucket = {
  "alex-test" = {
    bucket_name             = "alex-test-me12"
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
    bucket_versioning       = "Disabled"
    s3_notification         = [
      {
        id = "this"
        lambda_arn = "arn:aws:lambda:eu-west-1:582037776064:function:alex_test"
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "this.txt"
      },
      {
        id = "two"
        lambda_arn = "arn:aws:lambda:eu-west-1:582037776064:function:alex_test"
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "true.txt"
      }
    ]
    sqs_queue = []
    sns_topic = []
  }
}
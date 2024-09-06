lambda_functions = {
  "this" = {
    handler              = "test-1"
    runtime              = "python3.9"
    lambda_function_path = "app1"
    env_variables        = {
        TRY = "this"
    }
  }
    "this1" = {
      handler = "test-2"
      runtime = "python3.9"
      lambda_function_path = "app2"
      env_variables = {
      }
    }
}
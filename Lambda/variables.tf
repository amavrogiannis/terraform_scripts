variable "lambda_functions" {
  type = map(object({
    handler              = string
    runtime              = string
    lambda_function_path = string
    env_variables        = optional(map(string))
  }))
}
variable "aws_region" {
  description = "AWS region for all resources."
  type    = string
  default = "sa-east-1"
}

variable bucket_name {
  type        = string
  default     = "bkt-lambdas"
  description = "description"
}

variable "lambda_name" {
  description = "Lambda name."
  type    = string
  default = "lambda-springboot-snapstart"
}

variable "lambda_handler" {
  description = "File that have the main function"
  type        = string
  default     = "org.springframework.cloud.function.adapter.aws.FunctionInvoker::handleRequest"
}


variable "function_name" {
  type        = string
  default     = "lambda-springboot-snapstart"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  account_id           = data.aws_caller_identity.current.account_id
  lambda_app_name      = "app"
  lambda_app_zip_name  = "app-${var.lambda_name}.zip"
  lambda_exec_role_arn = "arn:aws:iam::${local.account_id}:role/serverless_lambda"
}


data "archive_file" "lambda_file" {
  type = "zip"

  source_dir  = "../${local.lambda_app_name}"
  output_path =  "../${local.lambda_app_zip_name}"
}

resource "aws_s3_object" "lambda_object_s3" {
  bucket = var.bucket_name

  key    = local.lambda_app_zip_name
  source = data.archive_file.lambda_file.output_path

  etag = filemd5(data.archive_file.lambda_file.output_path)
}

resource "aws_lambda_function" "lambda_snapstart" {
  function_name = var.function_name

  s3_bucket = var.bucket_name
  s3_key    = aws_s3_object.lambda_object_s3.key

  runtime = "java11"
  handler = var.lambda_handler

  source_code_hash = data.archive_file.lambda_file.output_base64sha256

  role = local.lambda_exec_role_arn
}

resource "aws_cloudwatch_log_group" "cw__lambda" {
  name = "/aws/lambda/${aws_lambda_function.lambda_snapstart.function_name}"

  retention_in_days = 1
}
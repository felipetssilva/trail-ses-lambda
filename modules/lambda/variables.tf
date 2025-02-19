variable "lambda_role_name" {
  type    = string
  default = "lambda_ses_role"
}

variable "lambda_s3_id" {
  type    = string
  default = "aws_s3_bucket.lambda_s3.id"
}
variable "lambda_policy_name" {
  type    = string
  default = "lambda_ses_policy"
}

variable "lambda_function_name" {
  type    = string
  default = "lambda_events_sns_s3"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "python3.9"
}

variable "lambda_handler" {
  description = "Handler for Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_source_email" {
  type    = string
  default = "felipetssilva@gmail.com"
}

variable "lambda_filename" {
  type    = string
  default = "lambda_function.zip"
}
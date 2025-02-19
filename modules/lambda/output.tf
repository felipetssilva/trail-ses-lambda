output "lambda_role_name" {
  value = var.lambda_role_name
}

output "lambda_policy_name" {
  value = var.lambda_policy_name
}

output "lambda_function_name" {
  value = "lambda_events_sns_s3"
}

output "lambda_function_arn" {
  value = aws_lambda_function.notification_lambda.arn
}
output "lambda_handler" {
  value = var.lambda_handler
}

output "lambda_runtime" {
  value = var.lambda_runtime
}

output "lambda_source_email" {
  value = var.lambda_source_email
}

output "lambda_filename" {
  value = var.lambda_filename
}
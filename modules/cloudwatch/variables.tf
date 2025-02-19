variable "cloud_watch_event_rule_name" {
    type = string
    default = "aws_cloudwatch_event_rule.ec2_state_change.name"
}

variable "cloudwatch_event_target"{
    type = string
    default = "aws_cloudwatch_event_target.lambda.target_id"
}

variable "lambda_permission"{
    type = string   
    default = "aws_lambda_permission.allow_cloudwatch.action"
}

variable "lambda_function_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}
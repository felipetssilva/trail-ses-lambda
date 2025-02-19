resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name        = "capture-ec2-state-changes"
  description = "Capture all EC2 state changes"

  event_pattern = jsonencode({
    source      = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
  })
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change.name
  target_id = "SendToLambda"
  arn       = var.lambda_function_arn
}

# Lambda permission to allow CloudWatch Events
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatchEventsInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_state_change.arn
  depends_on = [ var.lambda_function_arn ]
}
# IAM role for Lambda
resource "aws_s3_bucket" "lambda_s3" {
  bucket = "lambda-bucket"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_s3.id
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
  }

# Lambda function
resource "aws_lambda_function" "notification_lambda" {
  filename      = var.lambda_filename
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"  
  runtime       = var.lambda_runtime

  s3_bucket = aws_s3_bucket.lambda_s3.id
  s3_key    = aws_s3_object.lambda_code.key

  environment {
    variables = {
      SOURCE_EMAIL = "felipetssilva@gmail.com"
      AWS_REGION   = "us-east-1"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for Lambda
# IAM Policy for S3, Lambda, CloudTrail, and SES
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_s3_cloudtrail_ses_policy"
  description = "Policy for Lambda to access S3, CloudTrail, and SES"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 permissions
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::trail-bucket",         
          "arn:aws:s3:::trail-bucket/*"        
        ]
      },
      # CloudTrail permissions
      {
        Effect = "Allow"
        Action = [
          "cloudtrail:LookupEvents",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:DescribeTrails"
        ]
        Resource = "*"
      },
      # SES permissions
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      },
      # Lambda permissions (for logging)
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}


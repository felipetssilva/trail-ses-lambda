terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
  backend "s3" {
    bucket = "s3-backend-ses2"
    key    = "s3-backup"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "cloudtrail-ses" {
  source               = "./modules/cloudtrail-ses"
  ses-notifications-s3 = aws_s3_bucket.trail_s3.id
  
}

module "lambda" {
  source = "./modules/lambda"
}

module "cloudwatch" {
  source               = "./modules/cloudwatch"
  lambda_function_arn  = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name
}

module "ec2-related-resources" {
  source = "./modules/ec2-related-resources"
}

resource "aws_s3_bucket" "trail_s3" {
  bucket = "trail-bucket"

  tags = {
    Name        = "trail-bucket"
    Environment = "Test"
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.trail_s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.trail_s3.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.trail_s3.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}



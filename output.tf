output "ses-notifications-s3" {
  value = aws_s3_bucket.trail_s3.id
}
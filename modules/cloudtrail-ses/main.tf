resource "aws_cloudtrail" "main" {
  name                          = "management-events-trail"
  s3_bucket_name               = var.ses-notifications-s3
  include_global_service_events = true
  is_multi_region_trail        = true
  enable_logging               = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}

# SES Email Identity
resource "aws_ses_email_identity" "email" {
  email = "felipetssilva@gmail.com"
}


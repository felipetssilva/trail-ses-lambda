variable  "cloudtrail_name" {
    type    = string
    default = "management-events-trail"
}   

variable  "ses_email" {
    type    = string
    default = "felipetssilva@gmail.com"
}

variable "ses-notifications-s3" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}
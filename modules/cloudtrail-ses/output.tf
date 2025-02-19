output "cloud_trail_arn" {
    value = aws_cloudtrail.main.arn 
}

output "cloud_trail_ses_email" {  
    value = aws_ses_email_identity.email.id
}
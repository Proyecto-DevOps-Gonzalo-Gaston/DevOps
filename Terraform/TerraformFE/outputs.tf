# Output variable definitions

output "arn" {
  description = "ARN of the S3 Bucket"
  value       = [for bucket_key, bucket in aws_s3_bucket.s3_bucket : bucket.arn]
}

output "name" {
  description = "Name (id) of the bucket"
  value       = [for bucket_key, bucket in aws_s3_bucket.s3_bucket : bucket.id]
}

output "domain" {
  description = "Domain Name of the bucket"
  value       = [for bucket_key, bucket in aws_s3_bucket.s3_bucket : bucket.website_domain]
}

output "endpoint" {
  description = "Endpoint Information of the bucket"
  value       = [for key, bucket in aws_s3_bucket.s3_bucket : {
    bucket_name = bucket.bucket
    endpoint    = bucket.website_endpoint
  }]
}


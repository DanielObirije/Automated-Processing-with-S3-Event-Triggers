output "bucket_arn" {
  description = "ARN of the S3 data processing bucket"
  value       = aws_s3_bucket.data_processing_bucket.arn
}

output "bucket_id" {
  description = "ID/name of the S3 data processing bucket"
  value       = aws_s3_bucket.data_processing_bucket.id
}
output "sns_arn" {
  description = "ARN of the sns data processing alart"
  value       = aws_sns_topic.data_processing_alarts.arn
}
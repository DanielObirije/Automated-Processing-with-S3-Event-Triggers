output "dlq_arn" {
  description = "ARN of the sns"
  value       = aws_sqs_queue.dead_letter_queue.arn
}

output "dlq_url" {
  description = "URL of the dlq "
  value       = aws_sqs_queue.dead_letter_queue.url
}

output "dlq_name" {
  description = "name of the dlq"
  value       = aws_sqs_queue.dead_letter_queue.name
}
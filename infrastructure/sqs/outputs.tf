output "dlq_arn" {
  description = "ARN of the sns data processing alart"
  value       = aws_sqs_queue.dead_letter_queue.arn
}
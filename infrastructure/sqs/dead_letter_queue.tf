
resource "aws_sqs_queue" "dead_letter_queue" {
  name = var.dlq_name
  visibility_timeout_seconds = var.dlq_visibility_timeout
  message_retention_seconds = var.dlq_message_retention
   kms_master_key_id = "alias/aws/sqs"
  tags = merge(var.common_tags,{
    Name = var.dlq_name
    Purpose = "Dead letter queue for failed data processing"
  })
}
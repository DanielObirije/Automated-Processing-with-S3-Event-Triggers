
resource "aws_sns_topic" "data_processing_alarts" {
  name = var.sns_topic_name
  tags = merge(var.common_tags ,{
     Name = var.sns_topic_name
     Purpose = "Data processing error notifications"
  })
}

resource "aws_sns_topic_subscription" "data_processing_subscription" {
  topic_arn =  aws_sns_topic.data_processing_alarts.arn
  protocol = "email"
  endpoint = var.notification_email

}
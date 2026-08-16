 resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
   count = var.enable_monitoring ? 1 : 0
   alarm_name = "${var.lambda_role_name}-errors"
   comparison_operator = "GreaterThanOrEqualToThreshold"
   evaluation_periods = "1"
   metric_name =  "Errors"
   namespace = "AWS/Lambda"
   period = "300"
   statistic = "Sum"
   threshold = "1"
   alarm_description   = "This metric monitors Lambda function errors"
   alarm_actions = [var.sns_topic_arn]

    depends_on ={
        function_name = var.lambda_role_name
    }

    tags = merge(var.common_tags,{
        Name  = "${var.lambda_role_name}-errors"
         Purpose = "Lambda error monitoring"
    })
 }


resource "aws_cloudwatch_metric_alarm" "sqs_messages" {
   count = var.enable_monitoring ? 1 : 0
   alarm_name = "${var.lambda_role_name}-errors"
   comparison_operator = "GreaterThanThreshold"
   evaluation_periods = "1"
   metric_name         = "ApproximateNumberOfVisibleMessages"
   namespace = "AWS/SQS"
   period = "300"
   statistic = "Average"
   threshold = "5"
   alarm_description   = "This metric monitors DLQ message count"
   alarm_actions = [var.sns_topic_arn]

   depends_on = {
     QueueName = var.dlq_name
   }

   tags = merge(var.common_tags,{
     Name = "${var.dlq_name}-messages"
     Purpose = "DLQ message monitoring"
   })
}

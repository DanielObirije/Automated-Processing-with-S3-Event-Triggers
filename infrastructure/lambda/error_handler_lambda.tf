
data "archive_file" "error_handler_zip" {
  type = "zip"
  output_path ="${path.module}/error_handler.zip" 
  source {
   content = file("${path.module}/../../src/error_handler/handler.py")
   filename = "handler.py"
  }
}

resource "aws_lambda_function" "error_handler" {
   filename = data.archive_file.error_handler_zip.output_path
   function_name = var.error_handler_name
   role = var.lambda_execution_arn
   handler = "error_handler.lambda_handler"
   runtime = "python3.9"
   timeout = var.data_processing_timeout
   memory_size = var.data_processing_memory
   source_code_hash = data.archive_file.error_handler_zip.output_base64sha256

   environment {
    variables = {
     SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.error_handler_logs,
     var.lambda_execution_attachment,
     var.lambda_execution_policy
   ]

  tags = merge(var.common_tags,{
    Name = var.lambda_function_name
    Purpose = "Error handler Lambda function"
  })

} 

resource "aws_lambda_event_source_mapping" "dlq_to_error_handler" {
  event_source_arn = var.dlq_arn
  function_name = aws_lambda_function.error_handler.arn
  batch_size = 10
  maximum_batching_window_in_seconds = 5
}

resource "aws_cloudwatch_log_group" "error_handler_logs" {
  name = "/aws/lambda/${var.error_handler_name}"
  retention_in_days = var.cloudwatch_log_retention
  tags = merge(var.common_tags,{
    Name = "/aws/lambda/${var.error_handler_name}"
    Purpose = "Error handler Lambda logs"
  })
}
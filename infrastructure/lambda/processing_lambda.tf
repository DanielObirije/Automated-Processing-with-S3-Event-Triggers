data "archive_file" "data_processor_zip" {
  type = "zip"
  output_path ="${path.module}/data_processing.zip" 
  source {
   content = file("${path.module}/../../src/data_processor/handler.py")
   filename = "handler.py"
  }
}


resource "aws_lambda_function" "data_processor" {
   filename = data.archive_file.data_processor_zip.output_path
   function_name = var.lambda_function_name
   role = var.lambda_execution_arn
   handler = "data_processor.lambda_handler"
   runtime = "python3.9"
   timeout = var.data_processing_timeout
   memory_size = var.data_processing_memory
   source_code_hash = data.archive_file.data_processor_zip.output_base64sha256

   environment {
    variables = {
      DLQ_URL = var.dlq_url
    }
  }
  dead_letter_config {
    target_arn = var.dlq_url
  }
  depends_on = [
     aws_cloudwatch_log_group.data_processor_logs,
     var.lambda_execution_attachment,
     var.lambda_execution_policy
   ]

  tags = merge(var.common_tags,{
    Name = var.lambda_function_name
    Purpose = "Data processing Lambda function"
  })
} 

resource "aws_lambda_permission" "s3_invoke_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processor.function_name
   principal     = "s3.amazonaws.com"
   source_arn =  var.s3_bucket_arn
}


resource "aws_cloudwatch_log_group" "data_processor_logs" {
  name = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.cloudwatch_log_retention
  tags = merge(var.common_tags,{
    Name = "/aws/lambda/${var.lambda_function_name}"
    Purpose = "Data processing Lambda logs"
  })
}
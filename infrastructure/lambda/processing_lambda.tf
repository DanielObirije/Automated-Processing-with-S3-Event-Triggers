data "archive_file" "data_processing" {
  type = "zip"
  output_path ="${path.module}/data_processing.zip" 
  source {
   content = file("${path.module}/../../src/data_processor/handler.py")
   filename = "handler.py"
  }
}


resource "aws_lambda_function" "data_processor" {
   filename = data.archive_file.data_processing
   function_name = var.lambda_function_name
   role = var.lambda_execution_arn
   handler = "data_processor.lambda_handler"
   runtime = "python3.9"
   timeout = var.data_processing_timeout
   memory_size = var.data_processing_memory
   source_code_hash = data.archive_file.data_processing.output_base64sha256

   environment {
    variables = {
      DLQ_URL = var.dlq_url
    }
  }
  dead_letter_config {
    target_arn = var.dlq_url
  }
  depends_on = [
     var.lambda_execution_attachment_arn,
     var.lambda_execution_policy_arn
   ]

  tags = merge(var.common_tags,{
    Name = var.lambda_function_name
    Purpose = "Data processing Lambda function"
  })

} 
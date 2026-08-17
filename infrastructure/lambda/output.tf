
output "lambda_function_arn" {
  description = "ARN for lambda function data processor"
  value      = aws_lambda_function.data_processor.arn
}


output "aws_lambda_permission" {
  description = "lambda permission "
  value      = aws_lambda_permission.s3_invoke_lambda 
}


output "aws_lambda_permission_name" {
  description = "name of the lambda persmission name"
  value       = aws_lambda_function.data_processor.function_name
}

output "aws_lambda_error_handler_name" {
  description = "name of the lambda persmission name"
  value       = aws_lambda_function.error_handler.function_name
}
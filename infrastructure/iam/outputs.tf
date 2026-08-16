output "lambda_execution_arn" {
  description = "ARN  role of the lambda execution"
  value       = aws_iam_role.lambda_execution_role.arn
}


output "lambda_execution_role_policy_attachment" {
  description = "ARN role policy attachment of the lambda execution"
  value      = aws_iam_role_policy_attachment.lambda_basic_execution
}


output "lambda_execution_role_policy" {
  description = "ARN role policy  of the lambda execution"
  value      = aws_iam_role_policy.lambda_execution_policy
}


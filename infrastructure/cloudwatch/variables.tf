variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring and alarms"
  type        = bool
  default     = true
}

variable "lambda_function_name" {
  description = "lambda  processor  name prefix"
  type        = string
}

variable "error_handler_name" {
  description = "lambda error handler name prefix"
  type        = string
}

variable "sns_topic_arn" {
  description = "sns topic arn"
  type        = string
}
variable "common_tags" {
  description = "Common tags for the S3 bucket"
  type        = map(string)
}

variable "dlq_name" {
  description = "name of the dlq"
  type       = string
}
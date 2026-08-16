variable "lambda_function_name" {
  description = "Name of the lambda function name"
  type        = string
}

variable "error_handler_name" {
  description = "Name of the lambda function error handler"
  type        = string
}

variable "lambda_execution_arn"  {
  description = "Name of the lambda function name"
  type        = string
}



variable "sns_topic_arn"  {
  description = "ARN of the sns data processing alart"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of s3"
  type        = string
}

variable "dlq_arn"  {
  description = "ARN of the dlq data processing alart"
  type        = string
}

variable "dlq_url"  {
  description = "URL of the dlq data processing alart"
  type        = string
}


variable "data_processing_timeout" {
  description = "Timeout for data processing Lambda function in seconds"
  type        = number
  default     = 300
  
  validation {
    condition     = var.data_processing_timeout >= 60 && var.data_processing_timeout <= 900
    error_message = "Lambda timeout must be between 60 and 900 seconds."
  }
}
variable "data_processing_memory" {
  description = "Memory allocation for data processing Lambda function in MB"
  type        = number
  default     = 512
  
  validation {
    condition     = var.data_processing_memory >= 128 && var.data_processing_memory <= 10240
    error_message = "Lambda memory must be between 128 and 10240 MB."
  }
}

variable "common_tags" {
  description = "Common tags for the S3 bucket"
  type        = map(string)
}

variable "lambda_execution_attachment"  {
  description = "ARN of the lambda execuation attachment"
  type        = string
}

variable "lambda_execution_policy" {
  description = "ARN of the lambda execuation policy"
  type        = string
}


variable "cloudwatch_log_retention" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 14
  
  validation {
    condition = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_log_retention)
    error_message = "CloudWatch log retention must be one of: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653."
  }
}
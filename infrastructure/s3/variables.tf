variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the S3 bucket"
  type        = map(string)
}

variable "enable_s3_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable encryption for S3 bucket and SQS queue"
  type        = bool
  default     = true
}

variable "data_prefix" {
  description = "S3 prefix for data files that should trigger processing"
  type        = string
  default     = "data/"
}


variable "lambda_function_arn" {
  description = "ARN for lambda function data processor"
  type = string
}


variable "aws_lambda_permission" {
  description = "lambda permission"
  type = object({
    id  = string
  })
}


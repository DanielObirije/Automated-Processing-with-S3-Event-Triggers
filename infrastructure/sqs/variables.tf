variable "dlq_name"  {
  description = "Name of the sns Dlq "
  type        = string
}

variable "common_tags" {
  description = "Common tags for the S3 bucket"
  type        = map(string)
}
variable "dlq_visibility_timeout" {
  description = "Visibility timeout for Dead Letter Queue in seconds"
  type        = number
  default     = 300
  
  validation {
    condition     = var.dlq_visibility_timeout >= 0 && var.dlq_visibility_timeout <= 43200
    error_message = "DLQ visibility timeout must be between 0 and 43200 seconds."
  }
}

variable "dlq_message_retention" {
  description = "Message retention period for Dead Letter Queue in seconds"
  type        = number
  default     = 1209600 # 14 days
  
  validation {
    condition     = var.dlq_message_retention >= 60 && var.dlq_message_retention <= 1209600
    error_message = "DLQ message retention must be between 60 and 1209600 seconds."
  }
}

variable "enable_encryption" {
  description = "Enable encryption for S3 bucket and SQS queue"
  type        = bool
  default     = true
}

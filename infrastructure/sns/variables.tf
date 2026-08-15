variable "sns_topic_name" {
  description = "Name of the Sns topic"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the S3 bucket"
  type        = map(string)
}

variable "notification_email" {
  description = "Email address for SNS notifications"
  type        = string
  default     = "admin@example.com"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.notification_email))
    error_message = "The notification_email must be a valid email address."
  }
}


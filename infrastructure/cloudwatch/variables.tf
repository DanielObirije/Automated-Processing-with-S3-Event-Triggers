variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring and alarms"
  type        = bool
  default     = true
}

variable "lambda_role_name" {
  description = "lambda  role name prefix"
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
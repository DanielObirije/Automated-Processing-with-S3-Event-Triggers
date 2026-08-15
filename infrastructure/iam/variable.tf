variable "lambda_role_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "common_tags" {
  description = "Common tags for the S3 bucket"
  type        = map(string)
}
variable "s3_bucket_arn" {
  description = "ARN of the S3 data processing bucket"
  type        = string
}
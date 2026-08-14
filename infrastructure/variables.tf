variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "data-processing"
}

variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name (will be made unique with random suffix)"
  type        = string
  default     = "data-processing"
}


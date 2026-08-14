data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "surffix" {
  length  = 6
  special = false
  upper   = false
}



locals {
#   bucket_name         = "{data-processing-bucket}-${random_string.suffix.result}"
#   lambda_function_name = "data-processing-processor-${random_string.suffix.result}"
#   error_handler_name   = "data-processing-error-handler-${random_string.suffix.result}"
#   dlq_name            = "data-processing-dlq-${random_string.suffix.result}"
#   sns_topic_name      = "data-processing-alerts-${random_string.suffix.result}"
#   lambda_role_name    = "data-processing-lambda-role-${random_string.suffix.result}"
  bucket_name         = "${var.bucket_name_prefix}-${random_string.suffix.result}"
  lambda_function_name = "${var.project_name}-processor-${random_string.suffix.result}"
  error_handler_name   = "${var.project_name}-error-handler-${random_string.suffix.result}"
  dlq_name            = "${var.project_name}-dlq-${random_string.suffix.result}"
  sns_topic_name      = "${var.project_name}-alerts-${random_string.suffix.result}"
  lambda_role_name    = "${var.project_name}-lambda-role-${random_string.suffix.result}"

  common_tags = merge(
    {
        Project = "Automated-Processing-with-S3-Event-Triggers"
        Environment = "${var.environment}"
        ManagedBy = "terraform"
        Recipe = "Automated-Processing-with-S3-Event-Triggers"
    }
  )
}
module "s3" {
  source = "./s3"
  bucket_name = local.bucket_name
  common_tags = local.common_tags
}



data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "surffix" {
  length  = 6
  special = false
  upper   = false
}



locals {
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

module "iam" {
  source = "./iam"
  lambda_role_name = local.lambda_function_name
  common_tags = local.common_tags
  s3_bucket_arn = module.s3.bucket_arn
  sns_topic_arn = module.sns.sns_arn
  dlq_arn  =  module.sqs.dlq_arn
}

module "lambda" {
  source = "./lambda"
  lambda_function_name = local.lambda_function_name
  lambda_execution_arn = module.iam.lambda_execution_arn
   dlq_arn  =  module.sqs.dlq_arn
   dlq_url  = module.sqs.dlq_url
   common_tags =  local.common_tags
   lambda_execution_attachment_arn =  module.iam.lambda_execution_role_policy_attachment_arn
  lambda_execution_policy_arn =  module.iam.lambda_execution_role_policy_arn
}

module "sns" {
  source = "./sns"
  sns_topic_name = local.sns_topic_name 
  common_tags = local.common_tags
}


module "sqs" {
  source = "./sqs"
  dlq_name = local.dlq_name 
  common_tags = local.common_tags
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "surffix" {
  length  = 6
  special = false
  upper   = false
}



locals {
  bucket_name         = "${var.bucket_name_prefix}-${random_string.surffix.result}"
  lambda_function_name = "${var.project_name}-processor-${random_string.surffix.result}"
  error_handler_name   = "${var.project_name}-error-handler-${random_string.surffix.result}"
  dlq_name            = "${var.project_name}-dlq-${random_string.surffix.result}"
  sns_topic_name      = "${var.project_name}-alerts-${random_string.surffix.result}"
  lambda_role_name    = "${var.project_name}-lambda-role-${random_string.surffix.result}"

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
  lambda_function_arn = module.lambda.lambda_function_arn
  aws_lambda_permission = module.lambda.aws_lambda_permission
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
   lambda_execution_attachment =  module.iam.lambda_execution_role_policy_attachment
  lambda_execution_policy =  module.iam.lambda_execution_role_policy
  error_handler_name = local.error_handler_name
  sns_topic_arn =  module.sns.sns_arn
   s3_bucket_arn = module.s3.bucket_arn
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

module "cloudwatch" {
  source = "./cloudwatch"
  lambda_function_name = module.lambda.aws_lambda_permission_name
  error_handler_name = module.lambda.aws_lambda_error_handler_name
  sns_topic_arn = module.sns.sns_arn
  common_tags =  local.common_tags
  dlq_name = module.sqs.dlq_name
}


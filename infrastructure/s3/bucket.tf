resource "aws_s3_bucket" "data_processing_bucket" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, {
    Name = var.bucket_name
    Purpose = "Data processing event source"
  })
}

resource "aws_s3_bucket_versioning" "data_processing_bucket_versioning" {
  bucket =  var.bucket_name
  versioning_configuration {
    status = var.enable_s3_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_processing_bucket_encryption" {
    count = var.enable_encryption ? 1 : 0
    bucket = aws_s3_bucket.data_processing_bucket.id
    rule {
      apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_public_access_block" "data_processing_bucket_access" {
  bucket = aws_s3_bucket.data_processing_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "data_processing_notification" {
  bucket = aws_s3_bucket.data_processing_bucket.arn
  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = var.data_prefix
  }
  depends_on = [var.aws_lambda_permission]
}
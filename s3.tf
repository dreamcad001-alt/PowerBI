provider "aws" {
  region = var.aws_region
}

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_name}-${var.env}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Environment = "Dev"
    Project     = "TerraformS3LambdaDemo"
  }
}

# Upload a file to S3
resource "aws_s3_object" "upload_data" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "Orders.xlsx"
  source = var.local_file_path
  etag   = filemd5(var.local_file_path)
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_s3_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM Policy for Lambda to access S3
resource "aws_iam_role_policy" "lambda_policy" {
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_s3.json
}

data "aws_iam_policy_document" "lambda_s3" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_bucket.arn}/*"]
  }
}

# Lambda Function
resource "aws_lambda_function" "read_s3" {
  function_name = "read_s3_data"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
}
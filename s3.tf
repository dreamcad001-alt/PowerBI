

resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_name}-${var.env}-212"

  tags = {
    Environment = var.env
    Owner       = "Anusha"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "upload_data" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "Orders.xlsx"
  source = "${path.module}/Orders.xlsx"
  etag   = filemd5("${path.module}/Orders.xlsx")
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_s3_role_PowerBI1"
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

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = "arn:aws:s3:::my-terraform-s3-bucket-dev-212/*"
      },
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::my-terraform-s3-bucket-dev-212"
      }
    ]
  })
}
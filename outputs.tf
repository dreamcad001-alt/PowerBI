output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.read_s3.function_name
}
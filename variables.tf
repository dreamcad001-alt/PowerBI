variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "my-terraform-s3-bucket-demo"
}

variable "C:\Users\Anusha\Downloads\Orders.xlsx" {
  description = "Path to the local file you want to upload"
  default     = "Orders.xlsx"
}

variable "s3_key_name" {
  description = "Name of the file in S3"
  default     = "Orders.xlsx"
}
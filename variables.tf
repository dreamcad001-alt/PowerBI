variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "my-terraform-s3-bucket"
}

variable "env" {
  default = "dev"
}

variable "local_file_path" {
  description = "Path to the local Excel file"
  default     = "Orders.xlsx"
}
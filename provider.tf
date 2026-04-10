provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket  = "local-test-s3-dev"
    key     = "terraform/state.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

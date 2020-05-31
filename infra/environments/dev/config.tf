provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">=0.12"

  backend "s3" {
    bucket = "benamotz-dev-terraform-state"
    key    = "weather-service/dev/benamotz-dev-terraform.state"
    region = "us-east-1"
  }
}

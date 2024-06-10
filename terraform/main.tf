terraform {

  required_version = "1.8.5"
  # backend "s3" {
  #   bucket = "sahasra-terraform-state" # Replace with your bucket name
  #   key    = "terraform.tfstate"       # This can be any path within the bucket
  #   region = "ap-south-1"              # Replace with your bucket region
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1" # Specify your AWS region
}

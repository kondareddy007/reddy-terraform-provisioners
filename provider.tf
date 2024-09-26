terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  #aws provider version not terraform version
    }
  }
 
   backend "s3" {
    bucket = "reddy1229-remote"
    key    = "provisioner"
    region = "us-east-1"
    dynamodb_table = "reddy1229-locking"
   } 

}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

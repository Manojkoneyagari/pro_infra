
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.59.0"
    }
  }

  backend "s3" {
    bucket       = "pro-infra"
    key          = "alb.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }


}

provider "aws" {

  region = "us-east-1"
}
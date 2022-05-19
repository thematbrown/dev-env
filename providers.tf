terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}

provider "aws" {
  region = "${var.region}"
  shared_credentials_files = ["credentials"]
  profile = "default"
}
  


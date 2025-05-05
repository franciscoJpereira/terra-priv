terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

variable "vpc_id" {
  type = string
  description = "VPC ID of where the security groups are going to be deployed"
}
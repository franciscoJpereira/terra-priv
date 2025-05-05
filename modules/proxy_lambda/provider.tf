terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

variable "bucket_name" {
  type = string
  description = "Name of the S3 bucket to which the Lambda function will proxy requests"
}

variable "subnet_ids" {
    type = list(string)
    description = "Subnet list for the lambda function"
}

variable "vpc_id" {
  type = string
  description = "VPC where the lambda is going to be deployed"
}

variable "proxy_lambda_sg_id" {
 type = string
 description = "Lambda proxy sg ID" 
}

variable "proxy_lambda_name" {
  type = string
  default = "s3_proxy_lambda"
}


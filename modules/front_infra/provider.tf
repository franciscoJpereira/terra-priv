terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

variable "dev_env" {
  type = bool
}

variable "subnet_ids"{
    type = list(string)
}

variable "proxy_lambda_function_name" {
  type = string
  default = "s3_proxy_lambda"
}

variable "vpc_id" {
  type = string
}

variable "front_s3_bucket_name" {
  type = string
}

variable "alb_sg_id" {
  type = string
  description = "Security group for front-end alb"
}
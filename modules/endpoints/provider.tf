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
}

variable "subnets_ids" {
  type = list(string)
}

variable "s3_endpoint_sg_id" {
  type = string
}

variable "api_gw_sg_id" {
  type = string
}
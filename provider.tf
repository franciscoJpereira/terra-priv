provider "aws" {
  region = "sa-east-1"
}

variable "vpc_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "dev_env" {
  type = bool
  default = true
}

variable "s3_bucket_name" {
  type = string
}

variable "base_paths" {
  type = list(string)
  description = "Base API paths for the microservices that are going to be served through the API Gateway"
}
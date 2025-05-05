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
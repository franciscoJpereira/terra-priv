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

variable "alb_sg_id" {
    type = string
}

variable "dev_env" {
  type = bool
  default = true
}

variable "vpce_network_ips" {
    type = list(string)
}


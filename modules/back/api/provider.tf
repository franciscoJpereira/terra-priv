terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

variable "api_doc" {
    type = string
    description = "OpenAPI specification that must be used for the REST API created here"
}

variable "api_name" {
    type = string
    description = "OpenAPI API name"
}

variable "vpce_id" {
    type = string
    description = "ID of the VPC endpoint from which the API will be accesed"
}

variable "vpc_link_id" {
  type = string
  description = "ID of the NLB that acts as a VPC Link for this API gatewa"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

variable "services" {
  type = list(string)
  description = "Task definition arns"
}

variable "services_names" {
  type = list(string)
  description = "Containers names"
}

variable "subnet_ids" {
  type = list(string)
  description = "Private subnet IDs"
}

variable "services_sgs" {
  type = list(string)
  description = "Services Sgs"
}

variable "services_port" {
  type = string
  description = "Port exposing the services"
}
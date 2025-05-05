resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.sa-east-1.s3"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = var.subnets_ids
  security_group_ids = [var.s3_endpoint_sg_id] 
}

resource "aws_vpc_endpoint" "api_gw_endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.sa-east-1.execute-api"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = var.subnets_ids
  security_group_ids = [var.api_gw_sg_id]
}

/*
# Commented out till ECS creation
resource "aws_vpc_endpoint" "ecr_endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.sa-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = var.subnets_ids
}
*/
locals {
  apigw_network_interface_ids = tolist(aws_vpc_endpoint.api_gw_endpoint.network_interface_ids)
  s3_vpce_network_interface_ids = tolist(aws_vpc_endpoint.s3_endpoint.network_interface_ids)
}

data "aws_network_interface" "api_gw_enis" {
  count = length(var.subnets_ids)
  id = local.apigw_network_interface_ids[count.index]
}

data "aws_network_interface" "s3_vpce_enis" {
  count = length(var.subnets_ids)
  id = local.s3_vpce_network_interface_ids[count.index] 
}

output "api_gw_endpoint_ips" {
  value = [for _, v in data.aws_network_interface.api_gw_enis: v.private_ip]
}

output "s3_endpoint_interfaces" {
  value = [for _, v in data.aws_network_interface.s3_vpce_enis: v.private_ip]
}

output "api_gw_endpoint_id" {
  value = aws_vpc_endpoint.api_gw_endpoint.id
}
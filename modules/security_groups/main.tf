data "aws_vpc" "current_vpc" {
  id = var.vpc_id
}

resource "aws_security_group" "back_alb_group" {
  name = "api_gw_alb_group"
  description = "security group for back serving alb"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "api_gw_vpce_sg" {
  name = "api_gw_vpce_group"
  description = "Security group for api gateway vpc endpoint"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "api_gw_lb_ingress_rule" {
  security_group_id = aws_security_group.api_gw_vpce_sg.id
  referenced_security_group_id = aws_security_group.back_alb_group.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_security_group" "vpc_link_sg" {
  name = "vpc_link_sg"
  description = "Security group for vpc link nlb"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "front_alb_group" {
    name = "front_alb_security_group"
    description = "security group for front serving alb"
    vpc_id = var.vpc_id
}

resource "aws_security_group" "lambda_group" {
    name = "s3_proxy_lambda_security_group"
    description = "security group for proxy lambda"
    vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "lambda_egress_rule" {
  security_group_id = aws_security_group.lambda_group.id
  cidr_ipv4 = data.aws_vpc.current_vpc.cidr_block 
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "s3_vpce_security_group" {
    name = "s3_vpce_security_group"
    description = "Security group for s3 vpce"
    vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "s3_vpce_from_alb" {
  security_group_id = aws_security_group.s3_vpce_security_group.id
  referenced_security_group_id = aws_security_group.front_alb_group.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

output "fron_alb_sg_id" {
 value = aws_security_group.front_alb_group.id 
}

output "s3_vpce_sg_id" {
    value = aws_security_group.s3_vpce_security_group.id
}

output "lambda_proxy_sg_id" {
    value = aws_security_group.lambda_group.id
}

output "api_gw_lb_sg_id" {
  value = aws_security_group.back_alb_group.id
}

output "vpc_link_nlb_sg_id" {
  value = aws_security_group.vpc_link_sg.id
}

output "api_gw_sg_id" {
    value = aws_security_group.api_gw_vpce_sg.id
}
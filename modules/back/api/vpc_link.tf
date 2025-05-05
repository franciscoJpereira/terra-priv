resource "aws_lb" "vpc_link" {
    name = "vpc-link"
    internal = true
    load_balancer_type = "network"
    security_groups = [var.vpc_link_sg]
    subnets = var.subnet_ids
}

#This works only for REST apis
#for HTTP APIs you should use aws_api_gatewayv2_vpc_link
resource "aws_api_gateway_vpc_link" "gateway_link" {
    name = "vpc-link-connection"
    description = "api gateway vpc link resource"
    target_arns = [aws_lb.vpc_link.arn]
}

output "vpc_link_nlb_id" {
    value = aws_lb.vpc_link.id
}
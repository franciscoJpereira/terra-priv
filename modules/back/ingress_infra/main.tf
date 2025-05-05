resource "aws_lb" "api_gw_alb" {
    name = "back-alb"
    internal = var.dev_env ? false : true
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets = var.subnets_ids
}

resource "aws_lb_listener" "api_gw_listener" {
  load_balancer_arn = aws_lb.api_gw_alb.arn
  port = var.dev_env ? "80" : "443"
  protocol = var.dev_env ? "HTTP" : "HTTPS"
  certificate_arn = var.dev_env ? null : "" #TODO: set this up so that it has a certificate
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }
}

resource "aws_lb_target_group" "api_target_group" {
  name = "api-gw-target-group"
  port = 443
  protocol = "HTTPS"
  target_type = "ip"
  vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "api_vpce_attachments" {
  count = length(var.vpce_network_ips)
  target_group_arn = aws_lb_target_group.api_target_group.arn
  target_id = var.vpce_network_ips[count.index]
}
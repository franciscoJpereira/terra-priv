resource "aws_lb" "front_alb" {
    name = "front-alb"
    internal = var.dev_env ? false : true
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets = var.subnet_ids
}

#Dev env target group
resource "aws_lb_target_group" "dev_env_alb_target_group" {
    count = var.dev_env ? 1 : 0
    name = "dev-env-alb-target-group"
    target_type = "lambda"
}

resource "aws_lambda_permission" "dev_target_group_permission" {
    count = var.dev_env ? 1 : 0
    statement_id = "AllowExecutionFromALB"
    action = "lambda:InvokeFunction"
    function_name = var.proxy_lambda_function_name
    principal = "elasticloadbalancing.amazonaws.com"
    source_arn = aws_lb.front_alb.arn
}

#HTTP Listener for dev environments
resource "aws_lb_listener" "dev_front_alb_listener" {
    count = var.dev_env ? 1 : 0
    load_balancer_arn = aws_lb.front_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.dev_env_alb_target_group[0].arn
    }
}

resource "aws_s3_bucket" "front_s3_bucket" {
    bucket = var.front_s3_bucket_name
    force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "front_s3_config" {
  bucket = aws_s3_bucket.front_s3_bucket.id
  index_document {
    suffix = "index.html"
  }
}

#HTTPS Listener for non-dev environments
/*resource "aws_lb_listener" "front_alb_listener" {
    count = var.dev_env ? 0 : 1
    load_balancer_arn = aws_lb.front_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      
    }
}*/

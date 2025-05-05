resource "aws_api_gateway_rest_api" "rest_api" {
    name = var.api_name
    put_rest_api_mode = "merge"

    endpoint_configuration {
      types = ["PRIVATE"]
      vpc_endpoint_ids = [var.vpce_id]
    }
}

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = "/{proxy+}"  
}

resource "aws_api_gateway_method" "any_method" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = "ANY"
  authorization = "NONE" #TODO: Change this
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.any_method.http_method
  type = "HTTP"
  uri = "https://www.google.com"
  
  connection_type = "VPC_LINK"
  connection_id = var.vpc_link_id
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name = var.api_name
}
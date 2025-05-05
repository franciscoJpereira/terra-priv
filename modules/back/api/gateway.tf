resource "aws_api_gateway_rest_api" "rest_api" {
    name = var.api_name
    put_rest_api_mode = "merge"

    endpoint_configuration {
      types = ["PRIVATE"]
      vpc_endpoint_ids = [var.vpce_id]
    }
}

resource "aws_api_gateway_resource" "proxy_resource_parent" {
  count = length(var.integrations)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = var.integrations[count.index]  
}

resource "aws_api_gateway_resource" "proxy_resource" {
  count = length(var.integrations)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_resource.proxy_resource_parent[count.index].id
  path_part = "{proxy+}" 
}

resource "aws_api_gateway_method" "any_method" {
  count = length(var.integrations)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy_resource[count.index].id
  http_method = "ANY"
  authorization = "NONE" #TODO: Change this
}

resource "aws_api_gateway_integration" "proxy_integration" {
  count = length(var.integrations)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy_resource[count.index].id
  http_method = aws_api_gateway_method.any_method[count.index].http_method
  integration_http_method = aws_api_gateway_method.any_method[count.index].http_method
  type = "HTTP"
  uri = "http://${aws_lb.vpc_link.dns_name}:${8080 + count.index}/{proxy}" #This should be the particular URI of a service
  
  connection_type = "VPC_LINK"
  connection_id = aws_api_gateway_vpc_link.gateway_link.id 
}
/*
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
*/

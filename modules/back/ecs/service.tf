/*
    Generates:
        - Service based on task definition
        - Load balancer attachment for the service
*/
/*
    This policy allows the ecs task definition to pull
    images from ECR
    TODO: This should be in another place
*/
resource "aws_iam_policy" "task_definition_policy" {
  name = "ECS-Service-Policy-ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ]
            Effect = "Allow"
            Resource = "*"
        }
    ]
  })
}

resource "aws_lb_target_group" "this" {
  count = length(var.services)

}

resource "aws_ecs_service" "this" {
    count = length(var.services)
    name = var.services_names[count.index] 
    task_definition = var.services[count.index]
    launch_type = "FARGATE" 

    network_configuration {
        subnets = var.subnet_ids
        security_groups = [var.services_sgs[count.index]]
        assign_public_ip = false
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.this[count.index].arn 
      container_name = var.services_names[count.index]
      container_port = var.services_port
    }
}
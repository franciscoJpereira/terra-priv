data "archive_file" "lambda_code" {
    type = "zip"
    source_dir = "${path.module}/lambda"
    output_path = "./lambda.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    
    principals {
      type = "Service"
      identifiers = [ "lambda.amazonaws.com" ]
    }

    actions = ["sts:AssumeRole"]
  }
}

data  "aws_iam_policy_document" "lambda_policy" {
    statement {
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:ListBucket",
        ]
        resources = [
            "arn:aws:s3:::${var.bucket_name}/*",
            "arn:aws:s3:::${var.bucket_name}"
        ]
    }
    statement {
      effect = "Allow"
      actions =[
        "ec2:*"
      ]
      resources = [
        "*"
      ]
    }
    statement {
      
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = ["arn:aws:logs:*:*:*"]
    }
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_actions_policy" {
    name = "proxy_lambda_actions_policy" 
    description = "Policy for Lambda to access the s3 bucket and logs into cloudwatch"
    policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_actions_attachment" {
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_actions_policy.arn
}



resource "aws_lambda_function" "proxy_lambda" {
    function_name = var.proxy_lambda_name 
    filename = data.archive_file.lambda_code.output_path
    source_code_hash = data.archive_file.lambda_code.output_base64sha256
    handler = "index.lambda_handler"
    runtime = "python3.11"
    role = aws_iam_role.lambda_role.arn

    vpc_config {
        subnet_ids = var.subnet_ids 
        security_group_ids = [var.proxy_lambda_sg_id] 
    }
}

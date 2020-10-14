resource "aws_lambda_layer_version" "lambda_layer_dependencies" {
  filename   = var.lambda_dependencies_filepath
  layer_name = "${local.function_name}-dependencies"

  compatible_runtimes = [
    "nodejs10.x"
  ]
  source_code_hash = filebase64sha256(var.lambda_dependencies_filepath)
}

resource "aws_lambda_alias" "public" {
  function_name    = aws_lambda_function.api.function_name
  function_version = aws_lambda_function.api.version
  name             = "public"

  lifecycle {
    ignore_changes = [
      function_version
    ]
  }
}

resource "aws_lambda_function" "api" {
  function_name    = "${local.function_name}-api"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  role             = aws_iam_role.lambda_exec.arn
  filename         = var.lambda_handler_filepath
  source_code_hash = filebase64sha256(var.lambda_handler_filepath)
  publish          = true

  layers = [
  aws_lambda_layer_version.lambda_layer_dependencies.arn]

  timeout     = 30
  memory_size = var.memory_size

  environment {
    variables = local.environment_variables
  }
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "${local.resource_name_prefix}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "service" {
  name = "${local.resource_name_prefix}-lambda-role"
  role = aws_iam_role.lambda_exec.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "logs:*",
        "sqs:*",
        "cloudwatch:*",
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "basic-exec-role" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_role_policy_attachment" "s3-lambda-exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.data_store_access.arn
}


resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.weather.id
  parent_id   = aws_api_gateway_rest_api.weather.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.weather.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.weather.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn
}


resource "aws_api_gateway_deployment" "weather" {
  depends_on = [
    aws_api_gateway_integration.lambda,
  ]

  rest_api_id = aws_api_gateway_rest_api.weather.id
  stage_name  = "public"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.weather.execution_arn}/*/*"
}


output "base_url" {
  value = aws_api_gateway_deployment.weather.invoke_url
}



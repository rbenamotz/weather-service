resource "aws_api_gateway_rest_api" "weather" {
  name        = "benamotz-${var.env}-weather-api-gateway"
  description = "Endpoint for weather API"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.weather.id
  resource_id   = aws_api_gateway_rest_api.weather.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.weather.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_alias.public.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.weather.id
  stage_name  = var.url_path
}

# resource "aws_api_gateway_base_path_mapping" "gateway_path_mapping" {
#   api_id      = aws_api_gateway_rest_api.weather.id
#   stage_name  = aws_api_gateway_deployment.weather.stage_name
#   domain_name = aws_api_gateway_domain_name.api.domain_name
# }
resource "aws_secretsmanager_secret" "openweathermap" {
  name = "${local.function_name}-openweathermap-api-key" 
}

resource "aws_secretsmanager_secret_version" "openweathermapApi" {
  secret_id     = aws_secretsmanager_secret.openweathermap.id
  secret_string = "33e8e8a1e12e7851e3871dd5907db62f"
}
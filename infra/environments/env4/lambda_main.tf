module "weather_lambda" {
  source                       = "../../modules/lambda_api"
  env                          = "env4"
  memory_size = 1024
}


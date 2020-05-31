module "weather_lambda" {
  source                       = "../../modules/lambda_api"
  env                          = "dev"
  name                         = "weather"
  lambda_dependencies_filepath = "${path.cwd}/../../../api/dist-layers/layers.zip"
  lambda_handler_filepath      = "${path.cwd}/../../../api/dist/build.zip"
  url_path                     = "public"
  sub_domain                   = "weather"
  root_domain_name             = "weather.benamotz.com"
  alarm_on_no_requests         = false
  secrets = [
    "arn:aws:secretsmanager:us-east-1:609431849922:secret:benamotz/*"
  ]

}


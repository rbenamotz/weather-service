module "weather_lambda" {
  source                       = "../../modules/lambda_api"
  env                          = "pp"
  name                         = "weather"
  lambda_dependencies_filepath = "${path.cwd}/../../../api/dist-layers/layers.zip"
  lambda_handler_filepath      = "${path.cwd}/../../../api/dist/build.zip"
  url_path                     = "public"
  sub_domain                   = "weather"
  root_domain_name             = "weather.benamotz.com"
  memory_size = 512
}


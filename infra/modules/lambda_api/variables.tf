variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'jenkins'"
  default = "weather"
}

variable "env" {
  type        = string
  description = "Environment name. Can be one of dev, pp, prod"
}

variable "lambda_handler_filepath" {
  type = string
  default = "../../../api/dist/build.zip"
}

variable "lambda_dependencies_filepath" {
  type = string
  default = "../../../api/dist-layers/layers.zip"
}

variable "environment_variables" {
  description = "Environment variables for lambda"
  type        = map
  default     = {}
}


variable "url_path" {
  type = string
  default = "public"
}

variable "sub_domain" {
  type = string
  default = "weather"
}


variable "root_domain_name" {
  type = string
  default = "weather.benamotz.com"
}


variable "memory_size" {
  type = number 
  default = 512
}


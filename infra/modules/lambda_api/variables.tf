variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "env" {
  type        = string
  description = "Environment name. Can be one of dev, pp, prod"
}

variable "lambda_handler_filepath" {
  type = string
}

variable "lambda_dependencies_filepath" {
  type = string
}

variable "environment_variables" {
  description = "Environment variables for lambda"
  type        = map
  default     = {}
}

variable "secrets" {
  type    = list
  default = []
}

variable "url_path" {
  type = string
}

variable "sub_domain" {}


variable "root_domain_name" {}


variable "create_log_groups" {
  type    = bool
  default = false
}

variable alarm_on_no_requests {
  description = "Whether to alert when no requests are being recieved from homenet for an env"
  default     = true
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

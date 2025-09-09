variable "namespace" { type = string }
variable "release_name" { type = string }
variable "chart_version" { type = string }
variable "service_type" { type = string, default = "LoadBalancer" }
variable "admin_user" { type = string }
variable "admin_password" { type = string }
variable "additional_values_override" { type = map(any), default = {} }


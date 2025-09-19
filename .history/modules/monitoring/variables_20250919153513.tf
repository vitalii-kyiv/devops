variable "namespace" { type = string, default = "monitoring" }
variable "enabled" { type = bool, default = false }

variable "kube_host" { type = string }
variable "kube_ca" { type = string }
variable "kube_token" { type = string, sensitive = true }



variable "release_name" { type = string, default = "jenkins" }
variable "namespace" { type = string, default = "jenkins" }
variable "helm_repo" { type = string, default = "https://charts.jenkins.io" }
variable "chart" { type = string, default = "jenkins" }
variable "chart_version" { type = string, default = "4.7.0" }
variable "values_file" { type = string, default = "${path.module}/values.yaml" }

variable "enabled" { type = bool, default = false }

variable "kube_host" { type = string }
variable "kube_ca" { type = string }
variable "kube_token" { type = string, sensitive = true }




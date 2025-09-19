variable "namespace" { type = string, default = "argocd" }
variable "release_name" { type = string, default = "argo-cd" }
variable "helm_repo" { type = string, default = "https://argoproj.github.io/argo-helm" }
variable "chart" { type = string, default = "argo-cd" }
variable "chart_version" { type = string, default = "5.51.6" }
variable "values_file" { type = string, default = "${path.module}/values.yaml" }

variable "enabled" { type = bool, default = false }

variable "kube_host" { type = string }
variable "kube_ca" { type = string }
variable "kube_token" { type = string, sensitive = true }




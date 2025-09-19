provider "helm" {
  alias = "incluster"
  kubernetes {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca)
    token                  = var.kube_token
  }
}

resource "helm_release" "kube_prometheus_stack" {
  count      = var.enabled ? 1 : 0
  provider   = helm.incluster
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  create_namespace = true
}



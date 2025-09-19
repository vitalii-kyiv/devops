resource "helm_release" "kube_prometheus_stack" {
  count      = var.enabled ? 1 : 0
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  create_namespace = true
}

resource "kubernetes_manifest" "prometheus_rule" {
  count = var.enabled ? 1 : 0
  manifest = yamldecode(file("${path.module}/rules.yaml"))
}



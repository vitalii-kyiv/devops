resource "kubernetes_namespace" "argocd" {
  metadata { name = var.namespace }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]
}

module "apps_chart" {
  source = "./charts"
  depends_on = [helm_release.argocd]

  namespace    = var.namespace
  repositories = var.repos
  applications = var.applications
}

output "hostname" {
  value = helm_release.argocd.status[0].load_balancer[0].ingress[0].hostname
}


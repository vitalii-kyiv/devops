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

resource "helm_release" "argocd_apps" {
  name      = "argocd-apps"
  chart     = var.apps_chart_path
  namespace = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      repositories = var.repos
      applications = var.applications
    })
  ]

  depends_on = [helm_release.argocd]
}

output "hostname" {
  value = helm_release.argocd.status[0].load_balancer[0].ingress[0].hostname
}


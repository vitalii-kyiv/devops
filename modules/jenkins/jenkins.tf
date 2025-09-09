resource "kubernetes_namespace" "jenkins" {
  metadata { name = var.namespace }
}

resource "helm_release" "jenkins" {
  name       = var.release_name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  values = [
    file("${path.module}/values.yaml"),
    yamlencode({
      controller = {
        adminUser     = var.admin_user
        adminPassword = var.admin_password
        serviceType   = var.service_type
      }
    }),
    yamlencode(var.additional_values_override)
  ]
}

output "url" {
  value = helm_release.jenkins.status[0].load_balancer[0].ingress[0].hostname
}


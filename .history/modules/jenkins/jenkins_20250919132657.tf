resource "helm_release" "jenkins" {
  count      = var.enabled ? 1 : 0
  name       = var.release_name
  repository = var.helm_repo
  chart      = var.chart
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = true
  values = [file(var.values_file)]
}




resource "helm_release" "jenkins" {
  name       = var.release_name
  repository = var.helm_repo
  chart      = var.chart
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = true
  values = [file(var.values_file)]
}



resource "helm_release" "argo_cd" {
  name       = var.release_name
  repository = var.helm_repo
  chart      = var.chart
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = true
  values = [file(var.values_file)]
}




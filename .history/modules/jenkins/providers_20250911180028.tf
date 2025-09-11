provider "helm" {
  kubernetes {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca)
    token                  = var.kube_token
  }
}

provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = base64decode(var.kube_ca)
  token                  = var.kube_token
}



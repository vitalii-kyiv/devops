# Example provider configuration for Jenkins module
# In real deployment, these would be configured in root module

provider "helm" {
  alias = "incluster"
  kubernetes {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca)
    token                  = var.kube_token
  }
}

provider "kubernetes" {
  alias = "incluster"
  host                   = var.kube_host
  cluster_ca_certificate = base64decode(var.kube_ca)
  token                  = var.kube_token
}

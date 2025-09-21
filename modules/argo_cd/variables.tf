variable "namespace" { 
  type        = string
  description = "Kubernetes namespace for ArgoCD"
  default     = "argocd"
}

variable "release_name" { 
  type        = string
  description = "ArgoCD Helm release name"
  default     = "argo-cd"
}

variable "helm_repo" { 
  type        = string
  description = "ArgoCD Helm repository URL"
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart" { 
  type        = string
  description = "ArgoCD Helm chart name"
  default     = "argo-cd"
}

variable "chart_version" { 
  type        = string
  description = "ArgoCD Helm chart version"
  default     = "5.51.6"
}

variable "values_file" { 
  type        = string
  description = "Path to ArgoCD values file"
  default     = "${path.module}/values.yaml"
}




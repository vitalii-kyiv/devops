variable "release_name" { 
  type        = string
  description = "Jenkins Helm release name"
  default     = "jenkins"
}

variable "namespace" { 
  type        = string
  description = "Kubernetes namespace for Jenkins"
  default     = "jenkins"
}

variable "helm_repo" { 
  type        = string
  description = "Jenkins Helm repository URL"
  default     = "https://charts.jenkins.io"
}

variable "chart" { 
  type        = string
  description = "Jenkins Helm chart name"
  default     = "jenkins"
}

variable "chart_version" { 
  type        = string
  description = "Jenkins Helm chart version"
  default     = "4.7.0"
}

variable "values_file" { 
  type        = string
  description = "Path to Jenkins values file"
  default     = "${path.module}/values.yaml"
}




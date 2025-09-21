variable "name" { 
  type        = string
  description = "Name of the EKS cluster"
  default     = "demo-eks"
}

variable "cluster_role_arn" { 
  type        = string
  description = "ARN of the IAM role for EKS cluster"
}

variable "node_role_arn" { 
  type        = string
  description = "ARN of the IAM role for EKS node group"
}

variable "subnet_ids" { 
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster"
}





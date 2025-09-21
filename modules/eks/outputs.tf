output "cluster_name" { 
  value = aws_eks_cluster.this.name 
  description = "Name of the EKS cluster"
}

output "cluster_arn" { 
  value = aws_eks_cluster.this.arn 
  description = "ARN of the EKS cluster"
}

output "cluster_security_group_id" { 
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id 
  description = "Security group ID of the EKS cluster"
}





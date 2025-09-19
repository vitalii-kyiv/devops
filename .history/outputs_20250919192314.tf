output "rds_endpoint" {
  value       = try(module.rds.rds_instance_endpoint, module.rds.aurora_cluster_endpoint)
  description = "Primary DB endpoint (RDS instance or Aurora cluster writer)"
}

output "rds_security_group_id" {
  value       = try(module.rds.security_group_id, null)
  description = "Security Group ID used by the DB"
}

output "overview" {
  value = {
    project_prefix = var.project_prefix
    region         = var.aws_region
    vpc_id         = try(module.vpc.vpc_id, null)
    ecr_repo_name  = "${var.project_prefix}-ecr"
    eks_cluster    = "${var.project_prefix}-eks"
    jenkins_ns     = "jenkins"
    argocd_ns      = "argocd"
    monitoring_ns  = "monitoring"
    iam_role       = module.iam.eks_role_name
  }
  description = "High-level overview of mock deployment identifiers"
}

# Service access information
output "jenkins_access" {
  value = {
    url      = module.jenkins.jenkins_url
    password = module.jenkins.admin_password
    namespace = module.jenkins.namespace
  }
  description = "Jenkins access information"
}

output "argocd_access" {
  value = {
    url      = module.argo_cd.argocd_url
    password = module.argo_cd.admin_password
    namespace = module.argo_cd.namespace
  }
  description = "Argo CD access information"
}




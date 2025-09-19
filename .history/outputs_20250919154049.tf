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
  }
  description = "High-level overview of mock deployment identifiers"
}




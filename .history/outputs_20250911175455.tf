output "rds_endpoint" {
  value       = try(module.rds.rds_instance_endpoint, module.rds.aurora_cluster_endpoint)
  description = "Primary DB endpoint (RDS instance or Aurora cluster writer)"
}

output "rds_security_group_id" {
  value       = try(module.rds.security_group_id, null)
  description = "Security Group ID used by the DB"
}



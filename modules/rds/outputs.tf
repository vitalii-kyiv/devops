output "security_group_id" {
  description = "Security Group ID used by the DB"
  value       = aws_security_group.this.id
}

output "db_subnet_group_name" {
  description = "DB Subnet Group name"
  value       = aws_db_subnet_group.this.name
}

output "parameter_group_name" {
  description = "Parameter group name used (instance or cluster)"
  value       = var.use_aurora ? one(aws_rds_cluster_parameter_group.cluster[*].name) : one(aws_db_parameter_group.instance[*].name)
}

# RDS Instance outputs
output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = var.use_aurora ? null : aws_db_instance.this[0].id
}

output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = var.use_aurora ? null : aws_db_instance.this[0].endpoint
}

output "rds_instance_port" {
  description = "RDS instance port"
  value       = var.use_aurora ? null : aws_db_instance.this[0].port
}

# Aurora outputs
output "aurora_cluster_id" {
  description = "Aurora cluster identifier"
  value       = var.use_aurora ? aws_rds_cluster.this[0].id : null
}

output "aurora_cluster_endpoint" {
  description = "Aurora cluster writer endpoint"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "Aurora cluster reader endpoint"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "aurora_writer_instance_id" {
  description = "Aurora writer instance identifier"
  value       = var.use_aurora ? aws_rds_cluster_instance.writer[0].id : null
}



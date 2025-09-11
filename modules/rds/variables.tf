variable "use_aurora" {
  description = "If true, deploy Aurora PostgreSQL cluster; if false, deploy single RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine logical type. Supported: postgres"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres"], var.engine)
    error_message = "Only 'postgres' is supported in this module version."
  }
}

variable "engine_version" {
  description = "Engine version (e.g., 14.10 for Postgres)"
  type        = string
  default     = "14.10"
}

variable "instance_class" {
  description = "Instance class (e.g., db.t3.medium or db.r6g.large for Aurora instances)"
  type        = string
  default     = "db.t3.medium"
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS instance (non-Aurora only)"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Initial database name (optional)"
  type        = string
  default     = ""
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "Allocated storage for RDS instance in GB (non-Aurora only)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for RDS instance (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on delete"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier (required if skip_final_snapshot = false)"
  type        = string
  default     = ""
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window (UTC), e.g. 03:00-04:00"
  type        = string
  default     = ""
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window (UTC), e.g. Sun:05:00-Sun:06:00"
  type        = string
  default     = ""
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID to place Security Group into"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for DB Subnet Group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access DB port"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}

variable "parameter_overrides" {
  description = "Map of parameter name => value to override defaults"
  type        = map(string)
  default     = {}
}

locals {
  is_postgres = var.engine == "postgres"

  engine_for_instance = local.is_postgres ? "postgres" : null
  engine_for_aurora   = local.is_postgres ? "aurora-postgresql" : null

  major_version = regex("^[0-9+]+", var.engine_version)

  # Parameter group family names
  instance_pg_family = local.is_postgres ? "postgres${local.major_version}" : null
  cluster_pg_family  = local.is_postgres ? "aurora-postgresql${local.major_version}" : null

  port = local.is_postgres ? 5432 : 3306

  # Default parameters for Postgres-compatible engines
  default_params = [
    {
      name         = "max_connections"
      value        = "200"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_statement"
      value        = "ddl"
      apply_method = "pending-reboot"
    },
    {
      name         = "work_mem"
      value        = "4MB"
      apply_method = "pending-reboot"
    }
  ]

  override_params = [for k, v in var.parameter_overrides : {
    name         = k
    value        = v
    apply_method = "pending-reboot"
  }]

  effective_params = length(local.override_params) > 0 ? local.override_params : local.default_params
}



# RDS Module (Aurora or Single RDS)

A universal module for provisioning either an Aurora PostgreSQL cluster or a single RDS PostgreSQL instance, controlled by the `use_aurora` variable.

- use_aurora = true → creates an Aurora Cluster + one writer instance
- use_aurora = false → creates a single `aws_db_instance`

In both modes it automatically creates:

- DB Subnet Group
- Security Group (ingress to port 5432 from `allowed_cidr_blocks`)
- Parameter Group with basic parameters (`max_connections`, `log_statement`, `work_mem`) which can be overridden via `parameter_overrides`.

This version supports only Postgres/Aurora PostgreSQL.

## Usage Example

```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora      = true
  engine          = "postgres"
  engine_version  = "14.10"
  instance_class  = "db.r6g.large"

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_cidr_blocks = ["10.0.0.0/16"]

  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "appdb-final"

  backup_retention_period      = 7
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "Sun:05:00-Sun:06:00"

  tags = {
    Project = "Demo"
    Env     = terraform.workspace
  }

  # Optional parameter overrides
  parameter_overrides = {
    max_connections = "300"
    log_statement   = "none"
  }
}
```

## Variables

- use_aurora (bool): true for Aurora, false for single RDS. Default: false.
- engine (string): DB engine. Supported: "postgres".
- engine_version (string): version (e.g., 14.10).
- instance_class (string): instance class (e.g., db.t3.medium or db.r6g.large for Aurora).
- multi_az (bool): Multi-AZ for standalone RDS only. Default: false.
- db_name (string): initial database name (optional).
- username (string): master username.
- password (string, sensitive): master password.
- allocated_storage (number): storage in GB (RDS only). Default: 20.
- storage_type (string): storage type (gp2/gp3/io1) for RDS. Default: gp3.
- deletion_protection (bool): enable deletion protection. Default: true.
- skip_final_snapshot (bool): skip final snapshot on delete. Default: false.
- final_snapshot_identifier (string): final snapshot name if not skipping.
- backup_retention_period (number): backup retention days. Default: 7.
- preferred_backup_window (string): backup window (UTC).
- preferred_maintenance_window (string): maintenance window (UTC).
- publicly_accessible (bool): whether the DB is publicly accessible (SG still restricts traffic). Default: false.
- vpc_id (string): VPC ID.
- subnet_ids (list(string)): private subnets for the DB.
- allowed_cidr_blocks (list(string)): CIDR blocks allowed to access the DB. Default: [].
- tags (map(string)): resource tags.
- parameter_overrides (map(string)): overrides for parameter group settings.

## How to switch DB type and parameters

- Switch between Aurora and RDS: set `use_aurora = true|false`.
- Change engine type: `engine` (currently only `postgres`).
- Change engine version: `engine_version` (e.g., "14.10").
- Change instance class: `instance_class` (e.g., `db.t3.medium`, `db.r6g.large`).
- Multi-AZ applies to standalone RDS only: `multi_az = true`.
- Use `parameter_overrides` for DB parameter tuning.

## Outputs

- Security Group ID, DB Subnet Group name
- For RDS: endpoint, port, id
- For Aurora: cluster endpoint, reader endpoint, writer instance id

> Note: the module creates a parameter group of the appropriate type (cluster for Aurora, instance for RDS) and applies basic parameters with the option to override them.

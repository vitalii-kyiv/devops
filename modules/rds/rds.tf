resource "aws_db_instance" "this" {
  count                   = var.use_aurora ? 0 : 1
  identifier              = "rds-instance"
  engine                  = local.engine_for_instance
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  multi_az                = var.multi_az
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  publicly_accessible     = var.publicly_accessible
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : (var.final_snapshot_identifier != "" ? var.final_snapshot_identifier : "final-${replace("${terraform.workspace}", "/[^a-zA-Z0-9-]/", "-")}-rds")
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window != "" ? var.preferred_backup_window : null
  maintenance_window      = var.preferred_maintenance_window != "" ? var.preferred_maintenance_window : null
  parameter_group_name    = one(aws_db_parameter_group.instance[*].name)
  port                    = local.port

  name            = var.db_name != "" ? var.db_name : null
  username        = var.username
  password        = var.password

  apply_immediately = false

  tags = merge(var.tags, {
    Name = "rds-instance"
  })
}




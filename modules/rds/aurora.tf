resource "aws_rds_cluster" "this" {
  count                          = var.use_aurora ? 1 : 0
  cluster_identifier             = "aurora-cluster"
  engine                         = local.engine_for_aurora
  engine_version                 = var.engine_version
  database_name                  = var.db_name != "" ? var.db_name : null
  master_username                = var.username
  master_password                = var.password
  db_subnet_group_name           = aws_db_subnet_group.this.name
  vpc_security_group_ids         = [aws_security_group.this.id]
  deletion_protection            = var.deletion_protection
  skip_final_snapshot            = var.skip_final_snapshot
  final_snapshot_identifier      = var.skip_final_snapshot ? null : (var.final_snapshot_identifier != "" ? var.final_snapshot_identifier : "final-${replace("${terraform.workspace}", "/[^a-zA-Z0-9-]/", "-")}-aurora")
  backup_retention_period        = var.backup_retention_period
  preferred_backup_window        = var.preferred_backup_window != "" ? var.preferred_backup_window : null
  preferred_maintenance_window   = var.preferred_maintenance_window != "" ? var.preferred_maintenance_window : null
  db_cluster_parameter_group_name = one(aws_rds_cluster_parameter_group.cluster[*].name)
  port                           = local.port

  tags = merge(var.tags, {
    Name = "aurora-cluster"
  })
}

resource "aws_rds_cluster_instance" "writer" {
  count                = var.use_aurora ? 1 : 0
  identifier           = "aurora-writer-1"
  cluster_identifier   = aws_rds_cluster.this[0].id
  instance_class       = var.instance_class
  engine               = local.engine_for_aurora
  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(var.tags, {
    Role = "writer"
  })
}



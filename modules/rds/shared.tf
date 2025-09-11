resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "rds-subnet-group"
  })
}

resource "aws_security_group" "this" {
  name        = "rds-sg"
  description = "Security group for RDS/Aurora"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "DB access"
      from_port   = local.port
      to_port     = local.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "rds-sg"
  })
}

# Parameter groups
resource "aws_db_parameter_group" "instance" {
  count  = var.use_aurora ? 0 : 1
  name   = "rds-instance-params"
  family = local.instance_pg_family

  dynamic "parameter" {
    for_each = local.effective_params
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(var.tags, {
    Name = "rds-instance-params"
  })
}

resource "aws_rds_cluster_parameter_group" "cluster" {
  count  = var.use_aurora ? 1 : 0
  name   = "aurora-cluster-params"
  family = local.cluster_pg_family

  dynamic "parameter" {
    for_each = local.effective_params
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(var.tags, {
    Name = "aurora-cluster-params"
  })
}



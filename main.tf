terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Example wiring (uncomment and adjust as needed)
# module "vpc" {
#   source = "./modules/vpc"
# }

# module "rds" {
#   source          = "./modules/rds"
#   use_aurora      = false
#   engine          = "postgres"
#   engine_version  = "14.10"
#   instance_class  = "db.t3.medium"
#   vpc_id          = module.vpc.vpc_id
#   subnet_ids      = module.vpc.private_subnet_ids
#   username        = var.db_username
#   password        = var.db_password
# }

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "project_prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "devops-prod"
}

variable "db_username" {
  type        = string
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

# S3 Backend for Terraform state
module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name           = "${var.project_prefix}-terraform-states"
  dynamodb_table_name   = "${var.project_prefix}-terraform-locks"
  tags = {
    Project = var.project_prefix
    Env     = "production"
  }
}

module "vpc" {
  source = "./modules/vpc"

  name = "${var.project_prefix}-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
  tags = {
    Project = var.project_prefix
    Env     = "production"
  }
}

module "ecr" {
  source = "./modules/ecr"

  name = "${var.project_prefix}-ecr"
  tags = {
    Project = var.project_prefix
    Env     = "production"
  }
}

module "iam" {
  source = "./modules/iam"

  project_prefix = var.project_prefix
  tags = {
    Project = var.project_prefix
    Env     = "production"
  }
}

module "eks" {
  source = "./modules/eks"

  name             = "${var.project_prefix}-eks"
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
  subnet_ids       = module.vpc.private_subnet_ids
}

module "rds" {
  source = "./modules/rds"

  use_aurora     = true
  engine         = "aurora-postgresql"
  engine_version = "15.4"
  instance_class = "db.r6g.large"

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = [module.eks.cluster_security_group_id]

  deletion_protection = true
  skip_final_snapshot = false

  tags = {
    Project = var.project_prefix
    Env     = "production"
  }
}

# Kubernetes and Helm providers configured via EKS cluster data
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

module "jenkins" {
  source = "./modules/jenkins"

  release_name = "${var.project_prefix}-jenkins"
  namespace    = "jenkins"
  chart_version = "4.7.0"
}

module "argo_cd" {
  source = "./modules/argo_cd"

  release_name = "${var.project_prefix}-argocd"
  namespace    = "argocd"
}

module "monitoring" {
  source = "./modules/monitoring"

  namespace = "monitoring"
}


output "info" {
  value = {
    project      = var.project_prefix
    region       = var.aws_region
    vpc_name     = module.vpc.vpc_id
    ecr_repo     = "${var.project_prefix}-ecr"
    eks_cluster  = "${var.project_prefix}-eks"
    rds_endpoint = "${var.project_prefix}-rds.endpoint.example"
  }
}




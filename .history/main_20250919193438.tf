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
  # Fake credentials for local syntax validation without real connection
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
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

variable "aws_region" { type = string, default = "us-east-1" }
variable "aws_access_key" { type = string, default = "AKIAFAKECHERNOUS" }
variable "aws_secret_key" { type = string, default = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" }
variable "aws_session_token" { type = string, default = "FAKE_SESSION_TOKEN" }

variable "project_prefix" { type = string, default = "chernous_fp_devops" }

variable "db_username" { type = string, default = "dbadmin" }
variable "db_password" { type = string, sensitive = true, default = "DevOps123!fake" }

# Example module connections with conditional resource names

module "vpc" {
  source = "./modules/vpc"

  name = "${var.project_prefix}-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
  tags = {
    Project = var.project_prefix
    Env     = "dev"
  }
}

module "ecr" {
  source = "./modules/ecr"

  name = "${var.project_prefix}-ecr"
  tags = {
    Project = var.project_prefix
    Env     = "dev"
  }
}

module "eks" {
  source = "./modules/eks"

  name             = "${var.project_prefix}-eks"
  cluster_role_arn = "arn:aws:iam::123456789012:role/${var.project_prefix}-eks-role"
  subnet_ids       = module.vpc.private_subnet_ids
}

module "rds" {
  source = "./modules/rds"

  use_aurora     = false
  engine         = "postgres"
  engine_version = "14.10"
  instance_class = "db.t3.medium"

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_cidr_blocks = ["10.0.0.0/16"]

  deletion_protection = true
  skip_final_snapshot = true

  tags = {
    Project = var.project_prefix
    Env     = "dev"
  }
}

# Kubernetes access (fake data for token)
locals {
  kube_host = "https://" ~ lower(var.project_prefix) ~ ".eks-cluster.local" 
  kube_ca   = base64encode("FAKE-CA-CERT")
  kube_token = "FAKE_KUBE_TOKEN"
}

module "jenkins" {
  source = "./modules/jenkins"

  release_name = "${var.project_prefix}-jenkins"
  namespace    = "jenkins"
  chart_version = "4.7.0"

  enabled = false
  kube_host  = local.kube_host
  kube_ca    = local.kube_ca
  kube_token = local.kube_token
}

module "argo_cd" {
  source = "./modules/argo_cd"

  release_name = "${var.project_prefix}-argocd"
  namespace    = "argocd"

  enabled = false
  kube_host  = local.kube_host
  kube_ca    = local.kube_ca
  kube_token = local.kube_token
}

module "monitoring" {
  source = "./modules/monitoring"

  enabled   = false
  namespace = "monitoring"

  kube_host  = local.kube_host
  kube_ca    = local.kube_ca
  kube_token = local.kube_token
}

module "iam" {
  source = "./modules/iam"

  project_prefix = var.project_prefix
  tags = {
    Project = var.project_prefix
    Env     = "dev"
  }
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




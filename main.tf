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

variable "aws_region" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string, sensitive = true }



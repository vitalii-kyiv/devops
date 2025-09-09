terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# These providers will be configured after EKS is created via provider aliases in modules
provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = base64decode(var.kube_ca)
  token                  = var.kube_token
  # or use exec auth if preferred
  alias = "from_vars"
}

provider "helm" {
  kubernetes {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca)
    token                  = var.kube_token
  }
  alias = "from_vars"
}

############################
# Remote state bootstrap
############################
# Optionally, you can comment-in and run s3-backend once locally to bootstrap state infra
module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name          = var.tf_state_bucket_name
  bucket_force_destroy = false
  dynamodb_table_name  = var.tf_state_lock_table
}

############################
# Core networking
############################
module "vpc" {
  source = "./modules/vpc"

  name               = var.project_name
  cidr_block         = var.vpc_cidr
  azs                = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

############################
# ECR repository for images
############################
module "ecr" {
  source = "./modules/ecr"

  name                     = "${var.project_name}-app"
  image_tag_mutability     = "MUTABLE"
  scan_on_push             = true
  lifecycle_keep_last      = 10
}

############################
# EKS cluster
############################
module "eks" {
  source = "./modules/eks"

  cluster_name          = "${var.project_name}-eks"
  kubernetes_version    = var.kubernetes_version
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  public_subnet_ids     = module.vpc.public_subnet_ids
  node_desired_capacity = var.node_desired_capacity
  node_min_size         = var.node_min_size
  node_max_size         = var.node_max_size
}

############################
# Jenkins via Helm
############################
module "jenkins" {
  source = "./modules/jenkins"

  providers = {
    kubernetes = module.eks.kubernetes_provider
    helm       = module.eks.helm_provider
  }

  namespace                  = var.jenkins_namespace
  release_name               = var.jenkins_release_name
  chart_version              = var.jenkins_chart_version
  service_type               = var.jenkins_service_type
  admin_user                 = var.jenkins_admin_user
  admin_password             = var.jenkins_admin_password
  additional_values_override = {}
}

############################
# Argo CD via Helm
############################
module "argo_cd" {
  source = "./modules/argo_cd"

  providers = {
    kubernetes = module.eks.kubernetes_provider
    helm       = module.eks.helm_provider
  }

  namespace        = var.argocd_namespace
  release_name     = var.argocd_release_name
  chart_version    = var.argocd_chart_version
  apps_chart_path  = "${path.module}/modules/argo_cd/charts"
  repos            = var.argocd_repositories
  applications     = var.argocd_applications
}

############################
# Outputs for convenience
############################
output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "URL of the ECR repository"
}

output "jenkins_url" {
  value       = module.jenkins.url
  description = "Jenkins URL"
}

output "argocd_server" {
  value       = module.argo_cd.hostname
  description = "Argo CD server hostname"
}

############################
# Variables
############################
variable "project_name" { type = string }
variable "aws_region"   { type = string }

variable "tf_state_bucket_name" { type = string }
variable "tf_state_lock_table"  { type = string }

variable "vpc_cidr"            { type = string }
variable "azs"                 { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }

variable "kubernetes_version"    { type = string }
variable "node_desired_capacity" { type = number }
variable "node_min_size"         { type = number }
variable "node_max_size"         { type = number }

variable "jenkins_namespace"      { type = string }
variable "jenkins_release_name"    { type = string }
variable "jenkins_chart_version"   { type = string }
variable "jenkins_service_type"    { type = string }
variable "jenkins_admin_user"      { type = string }
variable "jenkins_admin_password"  { type = string }

variable "argocd_namespace"     { type = string }
variable "argocd_release_name"   { type = string }
variable "argocd_chart_version"  { type = string }

# Providers wired from outside or from data sources; optional for local/dev
variable "kube_host" { type = string, default = "" }
variable "kube_ca"   { type = string, default = "" }
variable "kube_token" { type = string, default = "" }

variable "argocd_repositories" {
  description = "List of Git repositories for Argo CD"
  type = list(object({
    name = string
    url  = string
    type = optional(string, "git")
  }))
  default = []
}

variable "argocd_applications" {
  description = "List of Argo CD Applications"
  type = list(object({
    name        = string
    project     = optional(string, "default")
    repo        = string
    path        = string
    target_rev  = optional(string, "main")
    namespace   = string
    sync_policy = optional(object({
      automated = optional(bool, true)
      prune     = optional(bool, true)
      selfHeal  = optional(bool, true)
    }), null)
    values = optional(map(any), {})
  }))
  default = []
}


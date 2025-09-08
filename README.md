Kubernetes EKS Infrastructure - Lesson 7

This project demonstrates the creation of an EKS Kubernetes cluster with the deployment of a Django application via Helm.

Infrastructure Components

1. S3 Backend Module

S3 Bucket: Stores Terraform state files

DynamoDB Table: State locking to prevent conflicts

2. VPC Module

VPC: Private network with CIDR 10.0.0.0/16

Public Subnets: 3 across different AZs

Private Subnets: 3 across different AZs

Internet Gateway: For public subnets

NAT Gateway: For private subnets

3. ECR Module

ECR Repository: Stores Django Docker images

Image Scanning: Automatic vulnerability scanning

Lifecycle Policy: Auto-cleanup of old images

4. EKS Module

EKS Cluster: Kubernetes v1.28

Node Group: Auto-scaled group of t3.medium nodes

IAM Roles: For cluster and nodes

Security Groups: Security configuration

5. Helm Chart (Django App)

Deployment: Django application deployment

Service: LoadBalancer for external access

HPA: Autoscaling from 2 to 6 pods

ConfigMap: Environment variables from Lesson 4

Prerequisites

Terraform: v1.0 or newer

AWS CLI: Configured with credentials

Docker: For image build & push

kubectl: Kubernetes CLI

Helm: For application deployment
Deployment Steps

1. Provision Infrastructure
   cd lesson-7
   terraform init # Initialize Terraform
   terraform plan # Preview plan
   terraform apply # Apply infrastructure

2. Configure kubectl
   chmod +x scripts/configure-kubectl.sh
   ./scripts/configure-kubectl.sh

3. Push Docker Image to ECR
   chmod +x scripts/push-to-ecr.sh
   ./scripts/push-to-ecr.sh

4. Deploy Django App via Helm
   chmod +x scripts/deploy-helm.sh
   ./scripts/deploy-helm.sh

Useful Commands
Terraform
terraform init # Initialize
terraform plan # Preview changes
terraform apply # Apply changes
terraform destroy # Destroy resources

Kubernetes
kubectl get nodes
kubectl get pods
kubectl get services
kubectl get configmaps
kubectl get hpa

Helm
helm install django-app charts/django-app
helm upgrade django-app charts/django-app
helm uninstall django-app
helm status django-app

Project Features
EKS Cluster

Kubernetes version: 1.28

Node type: t3.medium

Min nodes: 1

Max nodes: 4

Desired nodes: 2

Django Application

Image: From ECR repository

Ports: 8000 (container) → 80 (service)

Service Type: LoadBalancer

Health Checks: Liveness & Readiness probes

Autoscaling

HPA: Enabled

Min pods: 2

Max pods: 6

CPU Target: 70%

Memory Target: 70%

ConfigMap

Environment variables: From Lesson 4

Injected via: envFrom

Security: ConfigMap instead of Secret

Security

Resources are tagged

EKS cluster deployed in private subnets

ECR with security policies

ConfigMap for environment variables

ServiceAccount for application

License

MIT License

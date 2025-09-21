# DevOps Production Infrastructure

This repository contains production-ready infrastructure and deployment configuration for a Django application using Terraform, Kubernetes, and modern DevOps tools.

## 🏗️ Architecture

- **AWS Infrastructure**: VPC, EKS, RDS Aurora PostgreSQL, ECR
- **Kubernetes**: EKS cluster with EBS CSI driver
- **CI/CD**: Jenkins pipeline with ECR integration
- **GitOps**: ArgoCD for automated deployments
- **Monitoring**: Prometheus + Grafana stack
- **Security**: Encrypted S3 backend, private subnets, security groups

## 📋 Prerequisites

### Required Tools

- Terraform >= 1.5.0
- AWS CLI v2
- kubectl
- helm
- argocd CLI
- Docker

### AWS Requirements

- AWS Account with appropriate permissions
- AWS credentials configured via:
  - `AWS_PROFILE` environment variable, or
  - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <repository-url>
cd devops
```

### 2. Configure Backend

```bash
# Copy and customize backend configuration
cp backend.hcl.example backend.hcl
# Edit backend.hcl with your S3 bucket and DynamoDB table names
```

### 3. Bootstrap Backend Infrastructure

```bash
# First, create the S3 backend infrastructure
terraform init
terraform apply -target=module.s3_backend

# Re-initialize with S3 backend
terraform init -backend-config=backend.hcl
```

### 4. Configure Variables

```bash
# Copy and customize variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 5. Deploy Infrastructure

```bash
# Plan the deployment
terraform plan

# Apply the infrastructure
terraform apply
```

### 6. Verify Deployment

```bash
# Get cluster info
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks

# Check pods
kubectl get pods -A

# Check services
kubectl get svc -A
```

## 🔧 Configuration

### Environment Variables

Set these environment variables or use `terraform.tfvars`:

```bash
export TF_VAR_aws_region="us-east-1"
export TF_VAR_project_prefix="devops-prod"
export TF_VAR_db_username="dbadmin"
export TF_VAR_db_password="your-secure-password"
```

### Backend Configuration

The `backend.hcl` file should contain:

```hcl
bucket         = "your-terraform-states-bucket"
key            = "devops/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "your-terraform-locks-table"
encrypt        = true
```

## 🌐 Service Access

### Port Forwarding

Access services locally using port forwarding:

```bash
# Jenkins
kubectl port-forward -n jenkins svc/devops-prod-jenkins 8080:8080
# Access: http://localhost:8080

# ArgoCD
kubectl port-forward -n argocd svc/devops-prod-argocd-server 8081:80
# Access: http://localhost:8081

# Grafana
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
# Access: http://localhost:3000 (admin/prom-operator)
```

### Service URLs

- **Jenkins**: `http://devops-prod-jenkins.jenkins.svc.cluster.local:8080`
- **ArgoCD**: `http://devops-prod-argocd-server.argocd.svc.cluster.local:80`
- **Grafana**: `http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local:80`

## 🔄 CI/CD Pipeline

### Jenkins Pipeline

The Jenkins pipeline includes:

1. **ECR Login**: Authenticate with AWS ECR
2. **Build & Push**: Build Docker image and push to ECR with BUILD_NUMBER tag
3. **ArgoCD Deploy**: Update ArgoCD application with new image tag and sync

### Required Jenkins Credentials

Configure these credentials in Jenkins:

- `argocd-token`: ArgoCD admin token
- AWS credentials (via AWS_PROFILE or environment variables)

### ArgoCD Application

The Django application is deployed via ArgoCD with:

- **Repository**: This Git repository
- **Path**: `charts/django-app`
- **Parameters**: Image repository and tag set via Jenkins pipeline

## 📊 Monitoring

### Prometheus Metrics

- Cluster metrics via kube-prometheus-stack
- Application metrics (if configured in Django app)
- Custom dashboards available in Grafana

### Grafana Dashboards

- Kubernetes cluster overview
- Application performance metrics
- Resource utilization graphs

## 🔒 Security Features

### Infrastructure Security

- **Encrypted S3 Backend**: Terraform state encrypted at rest
- **Private Subnets**: RDS and EKS in private subnets
- **Security Groups**: Restrictive access rules
- **Encrypted RDS**: Aurora PostgreSQL with encryption enabled

### Application Security

- **Secrets Management**: Kubernetes secrets for sensitive data
- **Resource Limits**: CPU and memory limits on pods
- **Network Policies**: (Can be added for additional security)

## 🧹 Cleanup

### Destroy Infrastructure

```bash
# Destroy main infrastructure
terraform destroy

# Destroy S3 backend last (manually)
terraform destroy -target=module.s3_backend
```

### Manual Cleanup

If Terraform destroy fails, manually delete:

1. S3 bucket contents and bucket
2. DynamoDB table
3. ECR repository images
4. Any remaining AWS resources

## 📁 Project Structure

```
├── main.tf                    # Main Terraform configuration
├── backend.tf                 # Terraform backend configuration
├── outputs.tf                 # Terraform outputs
├── modules/                   # Terraform modules
│   ├── s3-backend/           # S3 + DynamoDB for state
│   ├── vpc/                  # VPC and networking
│   ├── eks/                  # EKS cluster
│   ├── rds/                  # RDS Aurora PostgreSQL
│   ├── ecr/                  # ECR repository
│   ├── iam/                  # IAM roles and policies
│   ├── jenkins/              # Jenkins Helm chart
│   ├── argo_cd/              # ArgoCD Helm chart
│   └── monitoring/           # Prometheus/Grafana stack
├── charts/django-app/        # Django application Helm chart
├── Django/                   # Django application code
├── Jenkinsfile              # Jenkins CI/CD pipeline
├── backend.hcl.example      # Backend configuration example
├── terraform.tfvars.example # Variables example
└── .gitignore               # Git ignore rules
```

## 🆘 Troubleshooting

### Common Issues

1. **Terraform Backend Issues**

   ```bash
   # Re-initialize backend
   terraform init -reconfigure -backend-config=backend.hcl
   ```

2. **EKS Access Issues**

   ```bash
   # Update kubeconfig
   aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks
   ```

3. **ArgoCD Sync Issues**

   ```bash
   # Check application status
   argocd app get django-app

   # Force sync
   argocd app sync django-app --force
   ```

4. **Jenkins Pipeline Issues**
   - Check AWS credentials in Jenkins
   - Verify ArgoCD token is valid
   - Ensure ECR repository exists

### Logs and Debugging

```bash
# Check pod logs
kubectl logs -n <namespace> <pod-name>

# Check service status
kubectl describe svc -n <namespace> <service-name>

# Check ingress/network issues
kubectl get ingress -A
```

## 📞 Support

For issues and questions:

1. Check the troubleshooting section
2. Review Terraform and Kubernetes logs
3. Verify AWS permissions and quotas
4. Check service health in respective namespaces

## 🔄 Updates and Maintenance

### Regular Maintenance

- Update Terraform and provider versions
- Rotate database passwords
- Update ArgoCD admin password
- Monitor resource usage and costs

### Scaling

- Adjust EKS node group sizes
- Modify RDS instance classes
- Update HPA settings in Django chart
- Scale Jenkins and ArgoCD resources as needed

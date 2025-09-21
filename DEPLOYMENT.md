# Production Deployment Guide

## Prerequisites

1. **AWS Account Setup**

   - AWS CLI configured with appropriate permissions
   - IAM user/role with permissions for: EKS, ECR, RDS, VPC, S3, DynamoDB, IAM

2. **Required Tools**

   ```bash
   # Install required tools
   brew install terraform awscli kubectl helm argocd
   # or on Ubuntu/Debian:
   # apt-get install terraform awscli kubectl helm
   ```

3. **AWS Credentials**

   ```bash
   # Option 1: AWS Profile
   export AWS_PROFILE=your-profile

   # Option 2: Environment Variables
   export AWS_ACCESS_KEY_ID=your-access-key
   export AWS_SECRET_ACCESS_KEY=your-secret-key
   export AWS_DEFAULT_REGION=us-east-1
   ```

## Step-by-Step Deployment

### 1. Clone Repository

```bash
git clone https://github.com/vitalii-kyiv/devops.git
cd devops
git checkout final_project
```

### 2. Configure Backend

```bash
# Copy and edit backend configuration
cp backend.hcl.example backend.hcl
# Edit backend.hcl with your unique bucket and table names
```

### 3. Configure Variables

```bash
# Copy and edit variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 4. Bootstrap Backend Infrastructure

```bash
# Initialize Terraform
terraform init

# Create S3 backend infrastructure first
terraform apply -target=module.s3_backend

# Re-initialize with S3 backend
terraform init -backend-config=backend.hcl
```

### 5. Deploy Complete Infrastructure

```bash
# Plan deployment
terraform plan

# Apply infrastructure
terraform apply
```

### 6. Configure kubectl

```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks
```

### 7. Verify Deployment

```bash
# Check all pods are running
kubectl get pods -A

# Check services
kubectl get svc -A

# Check ArgoCD applications
kubectl get applications -n argocd
```

## Accessing Services

### Port Forwarding

```bash
# Jenkins
kubectl port-forward -n jenkins svc/devops-prod-jenkins 8080:8080

# ArgoCD
kubectl port-forward -n argocd svc/devops-prod-argocd-server 8081:80

# Grafana
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

### Service URLs

- **Jenkins**: http://localhost:8080
- **ArgoCD**: http://localhost:8081 (admin/password from terraform output)
- **Grafana**: http://localhost:3000 (admin/prom-operator)

## CI/CD Setup

### 1. Get ArgoCD Admin Password

```bash
# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 2. Configure Jenkins

1. Access Jenkins at http://localhost:8080
2. Get initial admin password from terraform output
3. Install required plugins:
   - AWS Steps
   - Docker Pipeline
   - ArgoCD Plugin (if available)
4. Configure credentials:
   - AWS credentials (via environment or AWS profile)
   - ArgoCD token (create in ArgoCD UI)

### 3. Create Jenkins Pipeline

1. Create new pipeline job
2. Use Jenkinsfile from repository root
3. Configure build triggers as needed

## Monitoring Setup

### 1. Access Grafana

- URL: http://localhost:3000
- Username: admin
- Password: prom-operator

### 2. Import Dashboards

- Kubernetes cluster overview dashboards are pre-installed
- Custom dashboards can be added via ConfigMap

## Security Considerations

### 1. Database Security

- RDS is in private subnets
- Security groups restrict access to EKS cluster only
- Encryption enabled at rest

### 2. Network Security

- EKS cluster in private subnets
- NAT Gateway for outbound internet access
- Security groups with minimal required access

### 3. Secrets Management

- Database credentials stored as Terraform sensitive variables
- Kubernetes secrets for application configuration
- ArgoCD admin password managed by Terraform

## Troubleshooting

### Common Issues

1. **Terraform Backend Issues**

   ```bash
   terraform init -reconfigure -backend-config=backend.hcl
   ```

2. **EKS Access Issues**

   ```bash
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
   - Verify AWS credentials
   - Check ArgoCD token validity
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

## Cleanup

### Destroy Infrastructure

```bash
# Destroy main infrastructure
terraform destroy

# Destroy S3 backend last (manually)
terraform destroy -target=module.s3_backend
```

### Manual Cleanup

If Terraform destroy fails:

1. Delete S3 bucket contents and bucket
2. Delete DynamoDB table
3. Delete ECR repository images
4. Delete any remaining AWS resources

## Cost Optimization

### Resource Sizing

- EKS node group: t3.medium (adjust based on workload)
- RDS Aurora: db.r6g.large (adjust based on database load)
- EBS volumes: gp3 (cost-effective storage)

### Monitoring Costs

- Use AWS Cost Explorer to monitor spending
- Set up billing alerts
- Review and adjust resource sizes regularly

## Support

For issues:

1. Check troubleshooting section
2. Review Terraform and Kubernetes logs
3. Verify AWS permissions and quotas
4. Check service health in respective namespaces

## CI/CD for Django with Jenkins + EKS + Helm + Terraform + Argo CD

End-to-end GitOps pipeline:

- Build Docker image with Kaniko on Jenkins agent
- Push to Amazon ECR
- Update Helm chart tag in Git
- Argo CD auto-syncs to EKS

### Prerequisites

- Terraform >= 1.5, AWS CLI v2, kubectl, helm
- AWS account/IAM, access to a Git repo for the Helm chart

### Project layout

```
Progect/
├── main.tf, backend.tf, outputs.tf
├── modules/{s3-backend,vpc,ecr,eks,jenkins,argo_cd}
├── charts/django-app
├── Dockerfile, requirements.txt, Jenkinsfile
```

### Configure

Create `terraform.tfvars` (example values):

```hcl
project_name = "progect"
aws_region   = "eu-central-1"

tf_state_bucket_name = "my-tf-state-bucket"
tf_state_lock_table  = "my-tf-locks"

vpc_cidr             = "10.0.0.0/16"
azs                  = ["eu-central-1a", "eu-central-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

kubernetes_version    = "1.29"
node_desired_capacity = 2
node_min_size         = 2
node_max_size         = 4

jenkins_namespace     = "jenkins"
jenkins_release_name  = "jenkins"
jenkins_chart_version = "4.6.6"
jenkins_service_type  = "LoadBalancer"
jenkins_admin_user    = "admin"
jenkins_admin_password= "change-me"

argocd_namespace     = "argocd"
argocd_release_name  = "argocd"
argocd_chart_version = "6.7.12"

argocd_repositories = [
  { name = "infra", url = "https://github.com/your-org/your-infra.git" }
]

argocd_applications = [
  {
    name       = "django-app"
    repo       = "https://github.com/your-org/your-infra.git"
    path       = "charts/django-app"
    namespace  = "default"
    target_rev = "main"
    values     = {
      image = {
        repository = "<account>.dkr.ecr.eu-central-1.amazonaws.com/progect-app"
        tag        = "latest"
      }
    }
  }
]
```

### Deploy

```bash
terraform init
terraform apply
```

Outputs include ECR URL, Jenkins and Argo CD endpoints.

### Jenkins

- Create credential `git-creds` (Username/Password or PAT) for pushing chart changes
- Set env vars for the pipeline: `AWS_REGION`, `ECR_REPOSITORY_URL`, `HELM_CHARTS_REPO_URL`
- Run the Jenkinsfile pipeline; it builds, pushes, updates chart tag, pushes to main

### Argo CD

- Watches the chart repo and syncs to cluster automatically (auto-sync)

### Django chart

- `charts/django-app/values.yaml` holds `image.repository` and `image.tag` (updated by CI)

### Clean up

```bash
helm uninstall jenkins -n jenkins || true
helm uninstall argocd -n argocd || true
terraform destroy
```

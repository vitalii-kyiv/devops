# 🚀 Quick Start Guide - Production Deployment

## ⚡ Швидкий старт (5 хвилин)

### 1. Підготовка

```bash
# Клонувати репозиторій
git clone https://github.com/vitalii-kyiv/devops.git
cd devops
git checkout final_project

# Налаштувати AWS credentials
export AWS_PROFILE=your-profile
# або
export AWS_ACCESS_KEY_ID=your-key
export AWS_SECRET_ACCESS_KEY=your-secret
```

### 2. Конфігурація

```bash
# Створити конфігураційні файли
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars

# Відредагувати файли з вашими значеннями
nano backend.hcl    # S3 bucket та DynamoDB table names
nano terraform.tfvars  # db_username, db_password
```

### 3. Розгортання

```bash
# Ініціалізація та створення backend
terraform init
terraform apply -target=module.s3_backend

# Переініціалізація з S3 backend
terraform init -backend-config=backend.hcl

# Розгортання всієї інфраструктури
terraform apply
```

### 4. Доступ до сервісів

```bash
# Оновити kubeconfig
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks

# Port forwarding для доступу
kubectl port-forward -n jenkins svc/devops-prod-jenkins 8080:8080 &
kubectl port-forward -n argocd svc/devops-prod-argocd-server 8081:80 &
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80 &
```

### 5. Перевірка

- **Jenkins**: http://localhost:8080
- **ArgoCD**: http://localhost:8081
- **Grafana**: http://localhost:3000 (admin/prom-operator)

## 📋 Checklist

- [ ] AWS credentials налаштовані
- [ ] backend.hcl створений та налаштований
- [ ] terraform.tfvars створений з секретами
- [ ] S3 backend створений
- [ ] Вся інфраструктура розгорнута
- [ ] kubectl налаштований
- [ ] Сервіси доступні через port-forward

## 🔧 Налаштування CI/CD

### Jenkins

1. Отримати admin password: `terraform output jenkins_access`
2. Встановити плагіни: AWS Steps, Docker Pipeline
3. Налаштувати credentials для AWS та ArgoCD

### ArgoCD

1. Отримати admin password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
2. Створити ArgoCD token для Jenkins
3. Налаштувати Jenkins credentials

## 🆘 Troubleshooting

### Проблеми з Terraform

```bash
# Переініціалізація backend
terraform init -reconfigure -backend-config=backend.hcl

# Перевірка конфігурації
terraform validate
terraform plan
```

### Проблеми з Kubernetes

```bash
# Оновлення kubeconfig
aws eks update-kubeconfig --region us-east-1 --name devops-prod-eks

# Перевірка подів
kubectl get pods -A
kubectl describe pod <pod-name> -n <namespace>
```

### Проблеми з ArgoCD

```bash
# Перевірка статусу додатку
argocd app get django-app

# Примусова синхронізація
argocd app sync django-app --force
```

## 💰 Оптимізація витрат

- EKS nodes: t3.medium (можна зменшити до t3.small для dev)
- RDS Aurora: db.r6g.large (можна зменшити до db.r6g.medium)
- EBS volumes: gp3 (найбільш економічний)

## 🧹 Cleanup

```bash
# Видалення інфраструктури
terraform destroy

# Видалення S3 backend (останнім)
terraform destroy -target=module.s3_backend
```

## 📞 Підтримка

- Перевірити секцію Troubleshooting
- Переглянути логи Terraform та Kubernetes
- Перевірити AWS permissions та quotas
- Перевірити стан сервісів в відповідних namespace

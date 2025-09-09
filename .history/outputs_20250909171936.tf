output "vpc_id" { value = module.vpc.vpc_id }
output "private_subnet_ids" { value = module.vpc.private_subnet_ids }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "eks_cluster_name" { value = module.eks.cluster_name }
output "ecr_repository_url" { value = module.ecr.repository_url }
output "jenkins_url" { value = module.jenkins.url }
output "argocd_server" { value = module.argo_cd.hostname }


output "namespace" { value = var.namespace }
output "release_name" { value = var.release_name }

# Mock outputs for demonstration
output "argocd_url" { 
  value = "https://localhost:8081" 
  description = "Argo CD URL (use port-forward to access)"
}

output "admin_password" { 
  value = "admin123" 
  description = "Argo CD admin password (mock)"
  sensitive = false
}




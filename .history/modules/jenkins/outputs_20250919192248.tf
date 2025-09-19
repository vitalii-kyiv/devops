output "namespace" { value = var.namespace }
output "release_name" { value = var.release_name }

# Mock outputs for demonstration
output "jenkins_url" { 
  value = "http://localhost:8080" 
  description = "Jenkins URL (use port-forward to access)"
}

output "admin_password" { 
  value = "admin" 
  description = "Jenkins admin password (from values.yaml)"
  sensitive = false
}

output "release_name" { value = helm_release.jenkins.name }
output "namespace" { value = helm_release.jenkins.namespace }



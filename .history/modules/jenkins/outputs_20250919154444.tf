output "namespace" { value = var.namespace }
output "release_name" { value = var.release_name }

output "release_name" { value = helm_release.jenkins.name }
output "namespace" { value = helm_release.jenkins.namespace }



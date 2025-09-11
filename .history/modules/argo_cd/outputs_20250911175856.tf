output "release_name" { value = helm_release.argo_cd.name }
output "namespace" { value = helm_release.argo_cd.namespace }


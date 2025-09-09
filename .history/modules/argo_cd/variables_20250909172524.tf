variable "namespace" { type = string }
variable "release_name" { type = string }
variable "chart_version" { type = string }
variable "apps_chart_path" { type = string }
variable "repos" {
  type = list(object({
    name = string
    url  = string
    type = optional(string, "git")
  }))
}
variable "applications" {
  type = list(object({
    name        = string
    project     = optional(string, "default")
    repo        = string
    path        = string
    target_rev  = optional(string, "main")
    namespace   = string
    sync_policy = optional(object({
      automated = optional(bool, true)
      prune     = optional(bool, true)
      selfHeal  = optional(bool, true)
    }), null)
    values = optional(map(any), {})
  }))
}


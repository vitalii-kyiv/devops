variable "name" { type = string, default = "demo-eks" }
variable "cluster_role_arn" { type = string }
variable "subnet_ids" { type = list(string) }



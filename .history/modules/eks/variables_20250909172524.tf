variable "cluster_name" { type = string }
variable "kubernetes_version" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "node_desired_capacity" { type = number }
variable "node_min_size" { type = number }
variable "node_max_size" { type = number }
variable "node_instance_types" { type = list(string), default = ["t3.medium"] }
variable "node_capacity_type" { type = string, default = "ON_DEMAND" }
variable "ebs_csi_chart_version" { type = string, default = "2.31.0" }


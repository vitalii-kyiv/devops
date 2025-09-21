variable "project_prefix" { 
  type        = string
  description = "Prefix for IAM resource names"
}

variable "tags" { 
  type        = map(string)
  description = "Tags to apply to IAM resources"
  default     = {}
}



variable "name" { 
  type        = string
  description = "Name of the ECR repository"
}

variable "tags" { 
  type        = map(string)
  description = "Tags to apply to the ECR repository"
  default     = {}
}





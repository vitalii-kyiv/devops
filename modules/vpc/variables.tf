variable "name" { 
  type        = string
  description = "Name of the VPC"
  default     = "demo-vpc"
}

variable "cidr" { 
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" { 
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" { 
  type        = map(string)
  description = "Tags to apply to VPC resources"
  default     = {}
}





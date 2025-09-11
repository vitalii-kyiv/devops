variable "name" { type = string, default = "demo-vpc" }
variable "cidr" { type = string, default = "10.0.0.0/16" }
variable "azs" { type = list(string), default = ["us-east-1a", "us-east-1b"] }
variable "tags" { type = map(string), default = {} }



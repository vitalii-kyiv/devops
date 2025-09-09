variable "name" { type = string }
variable "image_tag_mutability" { type = string, default = "IMMUTABLE" }
variable "scan_on_push" { type = bool, default = true }
variable "lifecycle_keep_last" { type = number, default = 10 }
variable "tags" { type = map(string), default = {} }


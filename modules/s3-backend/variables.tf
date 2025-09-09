variable "bucket_name" { type = string }
variable "bucket_force_destroy" { type = bool, default = false }
variable "dynamodb_table_name" { type = string }
variable "tags" { type = map(string), default = {} }


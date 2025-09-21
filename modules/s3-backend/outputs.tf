output "bucket_name" { 
  value = aws_s3_bucket.tf_state.bucket 
  description = "Name of the S3 bucket for Terraform state"
}

output "dynamodb_table_name" { 
  value = aws_dynamodb_table.tf_locks.name 
  description = "Name of the DynamoDB table for Terraform state locking"
}





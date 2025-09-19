locals {
  bucket = var.bucket_name
}

resource "aws_s3_bucket" "state" {
  count  = 0
  bucket = local.bucket
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "state" {
  count  = 0
  bucket = aws_s3_bucket.state[0].id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  count  = 0
  bucket = aws_s3_bucket.state[0].id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}



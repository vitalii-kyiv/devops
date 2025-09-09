resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "keep last N images",
      selection    = {
        tagStatus     = "any",
        countType     = "imageCountMoreThan",
        countNumber   = var.lifecycle_keep_last,
        countUnit     = "images"
      },
      action = { type = "expire" }
    }]
  })
}


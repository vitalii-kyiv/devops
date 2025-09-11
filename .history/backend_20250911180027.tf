terraform {
  backend "s3" {
    bucket         = "CHANGE_ME-terraform-states"
    key            = "devops/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "CHANGE_ME-terraform-locks"
    encrypt        = true
  }
}



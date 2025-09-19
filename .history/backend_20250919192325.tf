terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
  
  # Example S3 backend configuration for real deployment
  # Uncomment and configure for production use:
  # backend "s3" {
  #   bucket         = "chernous_fp_devops-terraform-states"
  #   key            = "devops/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "chernous_fp_devops-terraform-locks"
  #   encrypt        = true
  # }
}




Lesson 5 — Terraform Remote State (S3 + DynamoDB)

This project demonstrates how to store Terraform state remotely in Amazon S3 with DynamoDB for state locking.
Remote state enables collaboration, prevents accidental state loss, and avoids concurrent apply runs.

Stack

Terraform >= 1.5

AWS S3 — stores terraform.tfstate

AWS DynamoDB — provides state locking

AWS CLI (optional, for one-time setup)

Project Structure
lesson-5/
├─ main.tf
├─ variables.tf
├─ outputs.tf
├─ README.md
└─ (other \*.tf files as needed)

Backend Configuration

terraform block (already included in the project):

terraform {
backend "s3" {
bucket = "vitalii-kyiv-terraform-backend"
key = "lesson-5/terraform.tfstate"
region = "us-west-2"
dynamodb_table = "terraform-locks"
encrypt = true
}
}

bucket — S3 bucket that stores state

key — path to the state file inside the bucket

region — AWS region of the bucket/table

dynamodb_table — table used for state locking

encrypt — enables server-side encryption for the state object

Prerequisites

AWS account with permissions to manage S3 and DynamoDB.

AWS credentials configured locally (any of the following works):

Environment variables:

export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-west-2

Or an AWS named profile via aws configure.

One-Time Remote State Setup

Create the S3 bucket and DynamoDB table (only once per account/region).

# Create S3 bucket for Terraform state

aws s3api create-bucket \
 --bucket vitalii-kyiv-terraform-backend \
 --region us-west-2 \
 --create-bucket-configuration LocationConstraint=us-west-2

# Optional but recommended: block public access

aws s3api put-public-access-block \
 --bucket vitalii-kyiv-terraform-backend \
 --public-access-block-configuration '{
"BlockPublicAcls": true,
"IgnorePublicAcls": true,
"BlockPublicPolicy": true,
"RestrictPublicBuckets": true
}'

# Enable default encryption (SSE-S3)

aws s3api put-bucket-encryption \
 --bucket vitalii-kyiv-terraform-backend \
 --server-side-encryption-configuration '{
"Rules": [{
"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}
}]
}'

# Create DynamoDB table for state locking

aws dynamodb create-table \
 --table-name terraform-locks \
 --attribute-definitions AttributeName=LockID,AttributeType=S \
 --key-schema AttributeName=LockID,KeyType=HASH \
 --billing-mode PAY_PER_REQUEST \
 --region us-west-2

If the bucket already exists, skip creation and keep using the same name.

Usage

# Initialize Terraform and configure the remote backend

terraform init

# See what will be created/changed

terraform plan

# Create or update infrastructure

terraform apply

# (Optional) Remove all managed resources

terraform destroy

Common Issues & Tips

Error acquiring the state lock
Someone else is running Terraform or a previous run crashed. Wait, or if you’re sure no run is active:

terraform force-unlock <LOCK_ID>

Bucket or table not found
Make sure the S3 bucket vitalii-kyiv-terraform-backend and DynamoDB table terraform-locks exist in us-west-2.

Changed backend settings
If you edit the backend config, re-run:

terraform init -reconfigure

Security

State may contain sensitive data (IDs, ARNs, sometimes secrets).
Using S3 encryption and DynamoDB locking helps protect it.

Restrict bucket access via IAM policies to only trusted users/roles.

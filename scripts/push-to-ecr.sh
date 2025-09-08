#!/bin/bash

# Script to build and push Django Docker image to ECR

set -e

# Configuration
AWS_REGION="us-west-2"
ECR_REPOSITORY="lesson-7-django-app"
IMAGE_TAG="latest"

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# ECR repository URL
ECR_REPO_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"

echo "Building Django Docker image..."

# Build the Docker image
docker build -t ${ECR_REPOSITORY}:${IMAGE_TAG} ../

echo "Logging in to ECR..."

# Get ECR login token and login
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

echo "Tagging image for ECR..."

# Tag the image for ECR
docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REPO_URI}:${IMAGE_TAG}

echo "Pushing image to ECR..."

# Push the image to ECR
docker push ${ECR_REPO_URI}:${IMAGE_TAG}

echo "Successfully pushed ${ECR_REPO_URI}:${IMAGE_TAG} to ECR"

# Output the image URI for use in Kubernetes
echo "Image URI: ${ECR_REPO_URI}:${IMAGE_TAG}" 
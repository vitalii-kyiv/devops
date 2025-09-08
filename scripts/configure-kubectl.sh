#!/bin/bash

# Script to configure kubectl for EKS cluster

set -e

# Configuration
CLUSTER_NAME="lesson-7-cluster"
AWS_REGION="us-west-2"

echo "Updating kubeconfig for EKS cluster..."

# Update kubeconfig for the EKS cluster
aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

echo "Verifying cluster access..."

# Test cluster access
kubectl get nodes

echo "Cluster access configured successfully!"
echo "You can now use kubectl to interact with the EKS cluster" 
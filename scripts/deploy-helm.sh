#!/bin/bash

# Script to deploy Django application using Helm

set -e

# Configuration
RELEASE_NAME="django-app"
NAMESPACE="default"
CHART_PATH="../charts/django-app"

echo "Updating Helm repositories..."
helm repo update

echo "Installing/upgrading Django application..."

# Install or upgrade the Helm chart
helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  --wait \
  --timeout 10m

echo "Waiting for deployment to be ready..."

# Wait for deployment to be ready
kubectl wait --for=condition=available --timeout=300s deployment/${RELEASE_NAME} -n ${NAMESPACE}

echo "Getting service information..."

# Get the LoadBalancer external IP
kubectl get service ${RELEASE_NAME} -n ${NAMESPACE}

echo "Deployment completed successfully!"
echo "You can access the application using the LoadBalancer external IP above" 
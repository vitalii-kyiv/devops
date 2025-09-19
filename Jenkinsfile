pipeline {
  agent any

  environment {
    PROJECT = 'chernous_fp_devops'
    IMAGE   = 'django'
    TAG     = '1.0.0-mock'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build (mock)') {
      steps {
        echo "Building ${env.PROJECT}/${env.IMAGE}:${env.TAG} (mock)"
      }
    }

    stage('Push to ECR (mock)') {
      steps {
        echo "Pushing to 123456789012.dkr.ecr.us-east-1.amazonaws.com/${env.PROJECT}/${env.IMAGE}:${env.TAG} (mock)"
      }
    }

    stage('ArgoCD Sync (mock)') {
      steps {
        echo 'Triggering ArgoCD app sync for chernous-fp-django (mock)'
      }
    }
  }
}



pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    ECR_REPOSITORY = 'devops-prod-ecr'
    IMAGE_NAME = 'django'
    ARGOCD_APP_NAME = 'django-app'
    ARGOCD_NAMESPACE = 'argocd'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('ECR Login') {
      steps {
        script {
          sh '''
            aws ecr get-login-password --region ${AWS_REGION} | \
            docker login --username AWS --password-stdin ${ECR_REGISTRY}
          '''
        }
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          def imageTag = "${ECR_REGISTRY}/${ECR_REPOSITORY}/${IMAGE_NAME}:${BUILD_NUMBER}"
          
          sh """
            cd Django
            docker build -t ${imageTag} .
            docker push ${imageTag}
          """
          
          // Store image tag for ArgoCD deployment
          env.IMAGE_TAG = imageTag
        }
      }
    }

    stage('Deploy via ArgoCD') {
      steps {
        script {
          withCredentials([string(credentialsId: 'argocd-token', variable: 'ARGOCD_TOKEN')]) {
            sh """
              # Login to ArgoCD
              argocd login argocd-server.${ARGOCD_NAMESPACE}.svc.cluster.local:443 \
                --username admin \
                --password ${ARGOCD_TOKEN} \
                --insecure
              
              # Update image tag parameter
              argocd app set ${ARGOCD_APP_NAME} \
                --parameter image.repository=${ECR_REGISTRY}/${ECR_REPOSITORY}/${IMAGE_NAME} \
                --parameter image.tag=${BUILD_NUMBER}
              
              # Sync the application
              argocd app sync ${ARGOCD_APP_NAME} --prune
              
              # Wait for sync to complete
              argocd app wait ${ARGOCD_APP_NAME} --health --timeout 300
            """
          }
        }
      }
    }
  }

  post {
    always {
      script {
        // Clean up local Docker images
        sh 'docker system prune -f'
      }
    }
    success {
      echo "Pipeline completed successfully. Image ${env.IMAGE_TAG} deployed to ArgoCD."
    }
    failure {
      echo "Pipeline failed. Check logs for details."
    }
  }
}



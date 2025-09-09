pipeline {
  agent none

  environment {
    AWS_DEFAULT_REGION = "${AWS_REGION}"
    ECR_REPO_URL       = "${ECR_REPOSITORY_URL}"
    DOCKER_CONFIG      = "/kaniko/.docker/"
    IMAGE_TAG          = "${env.GIT_COMMIT}"
    CHARTS_REPO_URL    = "${HELM_CHARTS_REPO_URL}"
    CHARTS_REPO_CRED   = "git-creds"
    CHART_PATH         = "charts/django-app/values.yaml"
  }

  stages {
    stage('Build & Push Image') {
      agent { label 'kaniko' }
      steps {
        container('kaniko') {
          sh '''
          cat > /kaniko/.docker/config.json <<EOF
          {"credHelpers":{"${ECR_REPO_URL%/*}":"ecr-login"}}
          EOF
          /kaniko/executor \
            --context $WORKSPACE \
            --dockerfile Dockerfile \
            --destination ${ECR_REPO_URL}:$IMAGE_TAG \
            --destination ${ECR_REPO_URL}:latest
          '''
        }
      }
    }

    stage('Update Helm values tag') {
      agent { label 'kaniko' }
      steps {
        container('jnlp') {
          checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[credentialsId: CHARTS_REPO_CRED, url: CHARTS_REPO_URL]]])
          sh '''
          set -e
          git config user.email "ci@local"
          git config user.name "jenkins-ci"
          # Update values.yaml without yq using sed (simple key replace)
          sed -i -E "s|(^\s*tag:\s*).*$|\1${IMAGE_TAG}|" ${CHART_PATH}
          sed -i -E "s|(^\s*repository:\s*).*$|\1${ECR_REPO_URL}|" ${CHART_PATH}
          git add ${CHART_PATH}
          git commit -m "ci: update image tag ${IMAGE_TAG}" || echo "No changes"
          git push origin HEAD:main
          '''
        }
      }
    }

    stage('Trigger Argo Sync') {
      when { expression { return env.ARGOCD_SERVER?.trim() }
      }
      agent { label 'kaniko' }
      steps {
        sh '''
        echo "Argo CD will auto-sync via Git; optionally trigger hook here."
        '''
      }
    }
  }
}


pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  parameters {
    string(name: 'IMAGE_NAME', defaultValue: 'your-docker-user/talentflow', description: 'Target Docker registry repo')
    booleanParam(name: 'PUSH_IMAGE', defaultValue: true, description: 'Push the built image to the registry')
    booleanParam(name: 'AUTO_DEPLOY', defaultValue: false, description: 'Trigger the deploy stage after a successful push')
  }

  environment {
    DOCKERHUB = credentials('dockerhub-creds')
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'npm ci'
      }
    }

    stage('Test') {
      steps {
        sh 'CI=true npm test -- --watch=false'
      }
    }

    stage('Build') {
      steps {
        sh 'npm run build'
      }
    }

    stage('Docker Build') {
      steps {
        sh '''
          docker build \
            -t ${params.IMAGE_NAME}:${IMAGE_TAG} \
            .
        '''
      }
    }

    stage('Docker Push') {
      when {
        expression { params.PUSH_IMAGE }
      }
      steps {
        sh '''
          echo "${DOCKERHUB_PSW}" | docker login -u "${DOCKERHUB_USR}" --password-stdin
          docker push ${params.IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }

    stage('Deploy') {
      when {
        expression { params.PUSH_IMAGE && params.AUTO_DEPLOY }
      }
      steps {
        sh '''
          echo "Deploying ${params.IMAGE_NAME}:${IMAGE_TAG}"
          # TODO: invoke your deployment script/command here.
        '''
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
      cleanWs()
    }
  }
}


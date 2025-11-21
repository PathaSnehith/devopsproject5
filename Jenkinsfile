pipeline {
  agent any

  options {
    timestamps()
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
        ansiColor('xterm') {
          sh 'npm ci'
        }
      }
    }

    stage('Test') {
      steps {
        ansiColor('xterm') {
          sh 'CI=true npm test -- --watch=false'
        }
      }
    }

    stage('Build') {
      steps {
        ansiColor('xterm') {
          sh 'npm run build'
        }
      }
    }

    stage('Docker Build') {
      steps {
        ansiColor('xterm') {
          sh '''
            docker build \
              -t ${params.IMAGE_NAME}:${IMAGE_TAG} \
              .
          '''
        }
      }
    }

    stage('Docker Push') {
      when {
        expression { params.PUSH_IMAGE }
      }
      steps {
        ansiColor('xterm') {
          sh '''
            echo "${DOCKERHUB_PSW}" | docker login -u "${DOCKERHUB_USR}" --password-stdin
            docker push ${params.IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }

    stage('Deploy') {
      when {
        expression { params.PUSH_IMAGE && params.AUTO_DEPLOY }
      }
      steps {
        ansiColor('xterm') {
          sh '''
            echo "Deploying ${params.IMAGE_NAME}:${IMAGE_TAG}"
            # TODO: invoke your deployment script/command here.
          '''
        }
      }
    }
  }

  post {
    always {
      ansiColor('xterm') {
        sh 'docker logout || true'
        cleanWs()
      }
    }
  }
}

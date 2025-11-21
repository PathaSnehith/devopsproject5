pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  stages {
    stage('Info') {
      steps {
        script {
          echo "=== Pipeline test - simple info ==="
          echo "Job: ${env.JOB_NAME}"
          echo "Branch/Commit: see built-in git info below"
          echo "Running on node: ${env.NODE_NAME}"
          echo "Workspace: ${pwd()}"
        }
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Platform check and simple command') {
      steps {
        script {
          if (isUnix()) {
            echo "Detected Unix-like node — running sh"
            sh 'echo "hello from sh"; uname -a || true'
          } else {
            echo "Detected Windows node — running bat"
            bat 'echo hello from bat & ver'
          }
        }
      }
    }

    stage('Simple echo stage') {
      steps {
        echo 'If you see this, stages are executing properly.'
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}

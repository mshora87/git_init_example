pipeline {
  agent any

  environment {
    IMAGE_NAME     = 'mywebsite-nginx'
    IMAGE_TAG      = "${env.BUILD_NUMBER}"
    CONTAINER_NAME = 'mywebsite'
    HOST_PORT      = '8081'       // change if you like
    CONTAINER_PORT = '80'
  }

  options {
    timestamps()
  }

  triggers {
    // Uncomment one:
     pollSCM('* * * * *')  // poll every ~1 min
    // OR set a GitHub webhook to trigger on push (recommended)
  }

  stages {
    stage('Checkout') {
      steps {
        // For a multibranch pipeline, use 'checkout scm'
        git url: 'https://github.com/mshora87/git_init_example.git', branch: 'main'
      }
    }

  stage('Docker permission check') {
      steps {
        sh '''
          set -eux
          docker version
          docker run --rm busybox:latest echo ok
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          set -eux
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
        '''
      }
    }

    stage('Deploy (restart container)') {
      steps {
        sh '''
          set -eux
          # Stop and remove existing container if it exists
          docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

          # Run a fresh container
          docker run -d --name ${CONTAINER_NAME} --restart unless-stopped \
            -p ${HOST_PORT}:${CONTAINER_PORT} ${IMAGE_NAME}:latest
          docker image rm -f $(docker image ls mywebsite-nginx --format '{{.Repository}}:{{.Tag}}' | grep -v ':latest')  
        '''
      }
    }
  }

  post {
    always {
      // optional: keep workspace clean
      cleanWs()
    }
  }
}

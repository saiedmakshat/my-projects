pipeline {
    agent any
    environment {
        // Bind the 'docker-hub-creds' credentials to an environment variable named DOCKER_CREDS
        DOCKER_CREDS = credentials('dockerhub') 
        GIT_HASH = GIT_COMMIT.take(8)
    }
    stages {
        stage('Login to Docker') {
            steps {
                // Use the environment variables created by credentials() for docker login
                sh "docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}" 
            }
        }
        stage('Build') {
            steps {
                sh "docker build . -t saiedmakshat/nginx-test:${GIT_HASH}"
            }
        }
        stage('PUSH') {
            steps {
                sh "docker push saiedmakshat/nginx-test:${GIT_HASH}"
            }
        }
        stage('RUN') {
            steps {
                sh "docker run -d --name nginx -p 8801:80 saiedmakshat/nginx-test:${GIT_HASH}"
            }
        }
        stage('Logout from Docker') {
            steps {
                sh "docker logout"
            }
        }
}
}
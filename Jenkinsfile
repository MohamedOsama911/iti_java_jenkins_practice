pipeline {
    agent any

    tools {
        maven 'mvn-3-5-4'
    }

    environment {
        // Use your Docker Hub username and the desired image name
        IMAGE_NAME = "mohamedosamaonmac/iti-java-app"
        // The Jenkins credential IDs you created
        DOCKER_HUB_CREDS_ID  = 'docker'
        GITHUB_CREDS_ID      = 'github'
    }

    stages {
        stage("Checkout Code") {
            steps {
                git(
                    branch: 'main',
                    url: 'https://github.com/MohamedOsama911/iti-java-jenkins-task.git',
                    credentialsId: env.GITHUB_CREDS_ID
                )
            }
        }

        stage("Build & Test Application") {
            steps {
                // This single command compiles, runs tests, and packages the app
                sh 'mvn clean package'
            }
            post {
                // Best practice: Always archive test results for viewing in Jenkins
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage("Archive Artifact") {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage("Build Docker Image") {
            steps {
                // FIX 1: Use the absolute path to Docker to permanently solve "command not found"
                sh "/usr/local/bin/docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage("Login & Push Docker Image") {
            steps {
                // FIX 2: Use the secure withCredentials block for your Docker token
                withCredentials([usernamePassword(credentialsId: env.DOCKER_HUB_CREDS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    
                    // Use the absolute path here as well for login
                    sh "echo ${DOCKER_PASS} | /usr/local/bin/docker login -u ${DOCKER_USER} --password-stdin"
                    
                    // And here for the push
                    sh "/usr/local/bin/docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "✅ Build & Push successful!"
            echo "🐳 Docker image: ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}
pipeline {
    agent any

    tools {
        maven 'mvn-3-5-4'
    }

    environment {
        // Your Docker Hub username and desired image name
        DOCKER_USERNAME      = 'mohamedosamaonmac'
        IMAGE_NAME           = "${DOCKER_USERNAME}/iti-java-app"
        // The Jenkins credential IDs you created
        DOCKER_TOKEN_CREDS_ID = 'docker' // This is your 'Secret text' credential
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
                sh 'mvn clean package'
            }
            post {
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
                sh "/usr/local/bin/docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage("Login & Push Docker Image") {
            steps {
                // *** THIS BLOCK IS NOW CORRECT FOR 'SECRET TEXT' ***
                // It loads the secret text into a variable named DOCKER_ACCESS_TOKEN
                withCredentials([string(credentialsId: env.DOCKER_TOKEN_CREDS_ID, variable: 'DOCKER_ACCESS_TOKEN')]) {
                    
                    // We use the variable here and provide the username directly
                    sh "echo ${DOCKER_ACCESS_TOKEN} | /usr/local/bin/docker login -u ${env.DOCKER_USERNAME} --password-stdin"
                    
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
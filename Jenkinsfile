pipeline {
    agent any

    tools {
        maven 'mvn-3-5-4'  // Make sure this matches your Jenkins Maven installation name
    }

    environment {
        IMAGE_NUM = "${BUILD_NUMBER}"          
        GITHUB_CREDS = credentials("github")   // Your GitHub token credential ID
        DOCKER_CREDS = credentials("docker")   // Your Docker token credential ID
        IMAGE_NAME = "mohamedosamaonmac/iti-java-app"  // Your Docker Hub username/repo
    }

    stages {
        stage("Checkout Code") {
            steps {
                git(
                    branch: 'main',
                    url: 'https://github.com/MohamedOsama911/iti-java-jenkins-task.git',
                    credentialsId: 'github'
                )
            }
        }

        stage("Build App") {
            steps {
                script {
                    mvnBuild("clean package")
                }
            }
        }

        stage("Test App") {
            steps {
                script {
                    mvnTest()
                }
            }
        }

        stage("Archive Jar") {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    dockerBuild("${IMAGE_NAME}", "v${IMAGE_NUM}")
                }
            }
        }

        stage("Docker Login") {
            steps {
                script {
                    dockerLoginWithToken("mohamedosamaonmac", "${DOCKER_CREDS}")
                }
            }
        }

        stage("Docker Push") {
            steps {
                script {
                    dockerPush("${IMAGE_NAME}", "v${IMAGE_NUM}")
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
            echo "🐳 Docker image: ${IMAGE_NAME}:v${IMAGE_NUM}"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}

// Maven build function
def mvnBuild(option) {
    sh "mvn ${option}"
}

// Maven test function
def mvnTest() {
    sh "mvn test"
}

// Docker login using Access Token
def dockerLoginWithToken(username, token) {
    sh "echo ${token} | docker login -u ${username} --password-stdin"
}

// Docker build
def dockerBuild(imageName, imageTag) {
    sh "docker build -t ${imageName}:${imageTag} ."
}

// Docker push
def dockerPush(imageName, imageTag) {
    sh "docker push ${imageName}:${imageTag}"
}
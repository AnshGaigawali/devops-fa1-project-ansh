pipeline {
    agent any
    
    environment {
        // Define environment variables
        DOCKER_IMAGE = 'devops-fa1-project-ansh'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_REGISTRY = 'your-registry' // Update this if using a registry
        APP_PORT = '8080'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    // Build the Docker image
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                script {
                    // Run basic tests - check if container starts successfully
                    sh """
                        # Test if the Docker image can run
                        docker run -d --name test-container-${BUILD_NUMBER} -p ${APP_PORT}:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        
                        # Wait for container to be ready
                        sleep 10
                        
                        # Test if the application is responding
                        curl -f http://localhost:${APP_PORT} || exit 1
                        
                        # Stop and remove test container
                        docker stop test-container-${BUILD_NUMBER}
                        docker rm test-container-${BUILD_NUMBER}
                    """
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                echo 'Running security scan...'
                script {
                    // Basic security check for Docker image
                    sh """
                        # Check for vulnerabilities (optional - requires tools like Trivy)
                        echo "Security scan would run here"
                        # trivy image ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }
        
        stage('Deploy to Staging') {
            steps {
                echo 'Deploying to staging environment...'
                script {
                    // Stop existing staging container if running
                    sh """
                        docker stop staging-app || true
                        docker rm staging-app || true
                        
                        # Deploy to staging
                        docker run -d --name staging-app -p 8081:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        
                        echo "Application deployed to staging: http://localhost:8081"
                    """
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            input {
                message "Deploy to production?"
                ok "Deploy"
                parameters {
                    choice(name: 'DEPLOY_ENVIRONMENT', choices: ['production', 'cancel'], description: 'Choose deployment environment')
                }
            }
            steps {
                echo 'Deploying to production environment...'
                script {
                    if (params.DEPLOY_ENVIRONMENT == 'production') {
                        sh """
                            # Stop existing production container if running
                            docker stop production-app || true
                            docker rm production-app || true
                            
                            # Deploy to production
                            docker run -d --name production-app -p 80:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                            
                            echo "Application deployed to production: http://localhost"
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
            // Clean up Docker images to save space
            script {
                sh """
                    # Remove old Docker images (keep last 5 builds)
                    docker images ${DOCKER_IMAGE} --format "table {{.Tag}}" | grep -v latest | grep -v TAG | sort -nr | tail -n +6 | xargs -I {} docker rmi ${DOCKER_IMAGE}:{} || true
                """
            }
        }
        success {
            echo 'Pipeline succeeded!'
            // You can add notifications here (email, Slack, etc.)
        }
        failure {
            echo 'Pipeline failed!'
            // Clean up any test containers
            script {
                sh """
                    docker stop test-container-${BUILD_NUMBER} || true
                    docker rm test-container-${BUILD_NUMBER} || true
                """
            }
        }
    }
}

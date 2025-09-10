# DevOps FA1 Project - Jenkins Pipeline

This project demonstrates a complete DevOps pipeline using Jenkins, Docker, and Git for a simple HTML web application.

## Project Structure
```
devops-fa1-project/
├── index.html          # Main web application
├── Dockerfile          # Docker container configuration
├── Jenkinsfile         # Jenkins pipeline (Linux/Unix)
├── Jenkinsfile.windows # Jenkins pipeline (Windows)
└── README.md          # This file
```

## Features
- **Containerized Web Application** using Docker and Nginx
- **Automated CI/CD Pipeline** with Jenkins
- **Multi-stage Deployment** (Staging → Production)
- **Automated Testing** and Health Checks
- **Cross-platform Support** (Linux and Windows)

## Jenkins Pipeline Stages

### 1. **Checkout**
- Pulls the latest code from Git repository

### 2. **Build Docker Image**
- Builds Docker image from Dockerfile
- Tags with build number and 'latest'

### 3. **Test Application**
- Runs container in test mode
- Performs health check with curl
- Cleans up test resources

### 4. **Deploy to Staging**
- Deploys to staging environment (port 8081)
- Accessible at `http://localhost:8081`

### 5. **Deploy to Production**
- Manual approval required
- Only runs on main branch
- Deploys to production (port 80)
- Accessible at `http://localhost`

## Setup Instructions

### Prerequisites
- Jenkins installed and running
- Docker installed and accessible to Jenkins
- Git configured
- curl available for testing

### Jenkins Setup

1. **Install Required Plugins:**
   - Docker Pipeline Plugin
   - Git Plugin
   - Pipeline Plugin

2. **Create New Pipeline Job:**
   - New Item → Pipeline
   - Name: `devops-fa1-project-ansh`

3. **Configure Pipeline:**
   - Pipeline Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: `https://github.com/AnshGaigawali/devops-fa1-project-ansh.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile` (or `Jenkinsfile.windows` for Windows)

4. **Configure Jenkins Agent:**
   - Ensure Jenkins agent has Docker access
   - For Windows: Use `Jenkinsfile.windows`
   - For Linux: Use `Jenkinsfile`

### Local Development

1. **Build and Run Locally:**
   ```bash
   # Build image
   docker build -t devops-fa1-project-ansh .
   
   # Run container
   docker run -p 8080:80 devops-fa1-project-ansh
   
   # Access application
   curl http://localhost:8080
   ```

2. **Test Pipeline Locally:**
   ```bash
   # Test build process
   docker build -t test-image .
   docker run -d --name test-app -p 8080:80 test-image
   curl http://localhost:8080
   docker stop test-app && docker rm test-app
   ```

## Pipeline Configuration

### Environment Variables
- `DOCKER_IMAGE`: Name of the Docker image
- `DOCKER_TAG`: Build number for versioning
- `APP_PORT`: Port for testing (8080)

### Deployment Ports
- **Testing**: 8080
- **Staging**: 8081
- **Production**: 80

## Troubleshooting

### Common Issues

1. **Docker Permission Issues:**
   ```bash
   # Add Jenkins user to docker group (Linux)
   sudo usermod -aG docker jenkins
   sudo systemctl restart jenkins
   ```

2. **Port Conflicts:**
   - Check if ports 80, 8080, 8081 are available
   - Stop conflicting containers: `docker stop $(docker ps -q)`

3. **Pipeline Fails on Windows:**
   - Use `Jenkinsfile.windows` instead of `Jenkinsfile`
   - Ensure Docker Desktop is running
   - Check PowerShell execution policy

### Health Check
The pipeline includes automated health checks:
- Container startup verification
- HTTP response testing
- Resource cleanup

## Security Considerations
- Regular image scanning (add Trivy or similar)
- Secrets management for production
- Network security for deployments
- Container resource limits

## Next Steps
1. Add automated tests (unit, integration)
2. Implement blue-green deployment
3. Add monitoring and logging
4. Set up container registry
5. Add notification systems (Slack, email)

## Author
**Ansh Gaigawali**  
DevOps FA1 Project - 2025

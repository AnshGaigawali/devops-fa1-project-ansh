# Jenkins Setup Guide for DevOps FA1 Project

## Prerequisites Installation

### Step 1: Install Docker Desktop (Recommended for this project)
1. **Download Docker Desktop:**
   - Go to: https://www.docker.com/products/docker-desktop/
   - Download Docker Desktop for Windows
   - Run the installer as Administrator
   - Restart your computer when prompted

2. **Verify Docker Installation:**
   ```powershell
   docker --version
   docker run hello-world
   ```

### Step 2: Install Jenkins using Docker (Easiest Method)

Once Docker is installed, run these commands:

```powershell
# Create a Jenkins home directory
mkdir C:\jenkins_home

# Run Jenkins in Docker container
docker run -d `
  --name jenkins-server `
  -p 8080:8080 `
  -p 50000:50000 `
  -v C:\jenkins_home:/var/jenkins_home `
  -v /var/run/docker.sock:/var/run/docker.sock `
  jenkins/jenkins:lts

# Check if Jenkins is running
docker ps
```

### Alternative: Manual Jenkins Installation

If you prefer not to use Docker:

1. **Download Jenkins:**
   - Go to: https://www.jenkins.io/download/
   - Download "Generic Java package (.war)"
   - Or download Windows installer

2. **Install Java (if not already installed):**
   ```powershell
   choco install openjdk11 -y
   ```

3. **Run Jenkins:**
   ```powershell
   java -jar jenkins.war --httpPort=8080
   ```

## Jenkins Initial Setup

### Step 3: Access Jenkins Web Interface

1. **Open your browser and go to:** `http://localhost:8080`

2. **Get the initial admin password:**
   ```powershell
   # If using Docker:
   docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
   
   # If using manual installation:
   # Check the console output for the password path
   ```

3. **Complete the setup wizard:**
   - Enter the initial admin password
   - Install suggested plugins
   - Create your admin user account

### Step 4: Install Required Plugins

Go to "Manage Jenkins" → "Plugins" → "Available plugins" and install:
- ✅ **Docker Pipeline Plugin**
- ✅ **Git Plugin** (usually pre-installed)
- ✅ **Pipeline Plugin** (usually pre-installed)
- ✅ **Blue Ocean** (optional, for better UI)

### Step 5: Configure System

1. **Go to:** "Manage Jenkins" → "System Configuration"
2. **Configure Git:** Usually auto-detected
3. **Configure Docker:** Should be available if Docker is installed

## Create Your Pipeline Job

### Step 6: Create New Pipeline

1. **Click "New Item"**
2. **Enter name:** `devops-fa1-project-ansh`
3. **Select "Pipeline"**
4. **Click "OK"**

### Step 7: Configure Pipeline

In the pipeline configuration:

1. **General Settings:**
   - Description: "DevOps FA1 Project - Automated CI/CD Pipeline"

2. **Build Triggers:**
   - ☑️ "GitHub hook trigger for GITScm polling" (if you want auto-builds)
   - ☑️ "Poll SCM" → Schedule: `H/5 * * * *` (checks every 5 minutes)

3. **Pipeline Definition:**
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: `https://github.com/AnshGaigawali/devops-fa1-project-ansh.git`
   - Branch Specifier: `*/main`
   - Script Path: `Jenkinsfile.windows`

4. **Click "Save"**

### Step 8: Test Your Pipeline

1. **Click "Build Now"**
2. **Monitor the build progress:**
   - Click on the build number (e.g., #1)
   - Click "Console Output" to see logs
   - Or use "Blue Ocean" for visual pipeline view

## Troubleshooting Common Issues

### Issue 1: Docker not accessible
```powershell
# Add Jenkins user to Docker group (if using manual installation)
# For Docker Desktop, ensure it's running
```

### Issue 2: Port conflicts
```powershell
# Check what's using port 8080
netstat -ano | findstr :8080

# Kill process if needed
taskkill /PID <process_id> /F
```

### Issue 3: Git authentication
- Use HTTPS URLs for public repositories
- For private repos, configure credentials in Jenkins

## Expected Pipeline Flow

When you run the pipeline, it will:

1. ✅ **Checkout** - Pull code from GitHub
2. ✅ **Build** - Create Docker image
3. ✅ **Test** - Run health checks
4. ✅ **Deploy to Staging** - Available at `http://localhost:8081`
5. ⏸️ **Manual Approval** - Prompt for production deployment
6. ✅ **Deploy to Production** - Available at `http://localhost:80`

## Quick Commands Reference

```powershell
# Check Jenkins status (Docker)
docker ps | findstr jenkins

# View Jenkins logs (Docker)
docker logs jenkins-server

# Restart Jenkins (Docker)
docker restart jenkins-server

# Stop Jenkins (Docker)
docker stop jenkins-server

# Start Jenkins (Docker)
docker start jenkins-server
```

## Next Steps After Setup

1. **Test the complete pipeline**
2. **Configure notifications** (email, Slack)
3. **Add more comprehensive tests**
4. **Set up monitoring**
5. **Configure deployment credentials**

---

**Note:** This guide assumes Windows environment with PowerShell. Adjust commands accordingly for other systems.

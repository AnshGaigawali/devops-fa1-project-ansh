@echo off
echo Testing Jenkins Pipeline Setup...
echo.

echo Step 1: Building Docker image...
docker build -t devops-fa1-project-ansh-test .
if %errorlevel% neq 0 (
    echo ERROR: Docker build failed!
    exit /b 1
)
echo ✅ Docker build successful!
echo.

echo Step 2: Running test container...
docker run -d --name pipeline-test -p 8082:80 devops-fa1-project-ansh-test
if %errorlevel% neq 0 (
    echo ERROR: Container start failed!
    exit /b 1
)
echo ✅ Container started successfully!
echo.

echo Step 3: Testing application response...
timeout /t 5 /nobreak >nul
curl -f http://localhost:8082 >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Application not responding!
    docker stop pipeline-test >nul 2>&1
    docker rm pipeline-test >nul 2>&1
    exit /b 1
)
echo ✅ Application responding correctly!
echo.

echo Step 4: Cleaning up...
docker stop pipeline-test >nul 2>&1
docker rm pipeline-test >nul 2>&1
docker rmi devops-fa1-project-ansh-test >nul 2>&1
echo ✅ Cleanup completed!
echo.

echo 🎉 Pipeline test completed successfully!
echo Your Jenkins pipeline should work perfectly!

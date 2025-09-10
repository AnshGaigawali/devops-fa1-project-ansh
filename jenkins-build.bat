@echo off
echo ========================================
echo Jenkins External Docker Build Script
echo ========================================
echo.

set IMAGE_NAME=devops-fa1-project-ansh
set BUILD_TAG=%1
if "%BUILD_TAG%"=="" set BUILD_TAG=latest

echo Building Docker image: %IMAGE_NAME%:%BUILD_TAG%
docker build -t %IMAGE_NAME%:%BUILD_TAG% .
if %errorlevel% neq 0 (
    echo ❌ Docker build failed!
    exit /b 1
)
echo ✅ Docker build successful!
echo.

echo Testing container startup...
docker run -d --name jenkins-test-%BUILD_TAG% -p 8082:80 %IMAGE_NAME%:%BUILD_TAG%
if %errorlevel% neq 0 (
    echo ❌ Container start failed!
    exit /b 1
)
echo ✅ Container started successfully!
echo.

echo Waiting for application to be ready...
timeout /t 5 /nobreak >nul

echo Testing application response...
curl -f http://localhost:8082 >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Application health check failed!
    docker stop jenkins-test-%BUILD_TAG% >nul 2>&1
    docker rm jenkins-test-%BUILD_TAG% >nul 2>&1
    exit /b 1
)
echo ✅ Application health check passed!
echo.

echo Cleaning up test container...
docker stop jenkins-test-%BUILD_TAG% >nul 2>&1
docker rm jenkins-test-%BUILD_TAG% >nul 2>&1
echo ✅ Cleanup completed!
echo.

echo 🎉 Build and test completed successfully!
echo Image %IMAGE_NAME%:%BUILD_TAG% is ready for deployment!

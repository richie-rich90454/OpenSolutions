# Build script for OpenSolutions
Write-Host "Building OpenSolutions frontend..."
Set-Location frontend
npm install
npm run build
Write-Host "Frontend build complete."

Write-Host "Copying frontend dist to Spring Boot static resources..."
$staticDir = "..\backend\opensolutions\src\main\resources\static"
if (Test-Path $staticDir) {
    Remove-Item -Recurse -Force $staticDir
}
Copy-Item -Recurse "dist" $staticDir
Write-Host "Static files copied."

Write-Host "Building OpenSolutions backend..."
Set-Location ..\backend\opensolutions
.\mvnw.cmd clean package -DskipTests
Write-Host "Backend build complete."

Write-Host "All builds finished successfully!"
Write-Host "Deploy: java -Xmx512m -jar backend/opensolutions/target/opensolutions-0.0.1-SNAPSHOT.jar"

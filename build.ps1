# Build script for OpenSolutions
Write-Host "Building OpenSolutions backend..."
Set-Location backend\opensolutions
.\mvnw.cmd clean package -DskipTests
Write-Host "Backend build complete."

Write-Host "Installing frontend dependencies..."
Set-Location ..\..\frontend
npm install
Write-Host "Building frontend..."
npm run build
Write-Host "Frontend build complete."
Write-Host "All builds finished successfully!"

# OpenClaw Skills GitHub Sync Script
# Sync your custom skills to GitHub

$skillsPath = "{USER_PATH}\.openclaw\workspace\skills"

Write-Host "=========================================="
Write-Host "OpenClaw Skills GitHub Sync"
Write-Host "=========================================="

# Set GitHub CLI path
$ghPath = "C:\Program Files\GitHub CLI\gh.exe"
$gitPath = "C:\Program Files\Git\cmd\git.exe"

# Check if Git is available
if (-not (Test-Path $gitPath)) {
    Write-Host "[ERROR] Git not found."
    exit 1
}

# Check if skills directory exists
if (-not (Test-Path $skillsPath)) {
    Write-Host "[ERROR] Skills path not found: $skillsPath"
    exit 1
}

# Set location to skills folder
Set-Location $skillsPath

# Get current status
Write-Host ""
Write-Host "Checking Git status..."
& $gitPath status --porcelain

$status = & $gitPath status --porcelain

if ($status) {
    Write-Host "Changes to commit:"
    $status | ForEach-Object { Write-Host "  $_" }
    
    Write-Host ""
    $commitMsg = "Skills sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    Write-Host "Commit message: $commitMsg"
    
    # Commit
    & $gitPath add .
    & $gitPath commit -m $commitMsg
    
    # Push to GitHub
    Write-Host ""
    Write-Host "Pushing to GitHub..."
    & $gitPath push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Sync completed!"
    } else {
        Write-Host "[FAIL] Sync failed!"
    }
} else {
    Write-Host "[OK] No changes to sync."
}

Write-Host ""
Write-Host "=========================================="


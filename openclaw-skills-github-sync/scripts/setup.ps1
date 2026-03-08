# OpenClaw Skills GitHub Sync - Interactive Setup

Write-Host "=========================================="
Write-Host "OpenClaw Skills GitHub Sync - Setup Wizard"
Write-Host "=========================================="
Write-Host ""

# Check GitHub CLI
$ghPath = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghPath) {
    Write-Host "GitHub CLI not installed" -ForegroundColor Red
    Write-Host "Please install first: winget install GitHub.cli" -ForegroundColor Yellow
    exit 1
}

Write-Host "1. GitHub login status check..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($authStatus -match "Logged in") {
    Write-Host "   Already logged in to GitHub" -ForegroundColor Green
} else {
    Write-Host "   Please login to GitHub first" -ForegroundColor Yellow
    Write-Host "   Run: gh auth login" -ForegroundColor Cyan
    exit 1
}

Write-Host ""
Write-Host "2. Set private skills local path" -ForegroundColor Yellow
Write-Host "   Example: C:\Users\YourName\openclaw-skills-private"
$privatePath = Read-Host "   Enter path"

Write-Host ""
Write-Host "3. Set public skills local path" -ForegroundColor Yellow
Write-Host "   Example: C:\Users\YourName\openclaw-skills-public"
$publicPath = Read-Host "   Enter path"

Write-Host ""
Write-Host "=========================================="
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=========================================="
Write-Host ""
Write-Host "Private Skills: $privatePath" -ForegroundColor White
Write-Host "Public Skills: $publicPath" -ForegroundColor White
Write-Host ""

# Save config
$config = @"
`$privatePath = `"$privatePath`"
`$publicPath = `"$publicPath`"
"@

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = Join-Path $scriptDir "config.ps1"
$config | Out-File -FilePath $configFile -Encoding UTF8

Write-Host "Config saved to: $configFile" -ForegroundColor Green

# Check Git repos
Write-Host ""
Write-Host "Checking Git repos..." -ForegroundColor Yellow

if (Test-Path $privatePath) {
    Set-Location $privatePath
    if (-not (Test-Path ".git")) {
        Write-Host "   Private repo not initialized, creating..." -ForegroundColor Yellow
        git init
        git config user.email "your@email.com"
        git config user.name "Your Name"
        Write-Host "   Please add remote manually: git remote add origin https://github.com/YOUR_USERNAME/your-repo.git" -ForegroundColor Cyan
    }
}

if (Test-Path $publicPath) {
    Set-Location $publicPath
    if (-not (Test-Path ".git")) {
        Write-Host "   Public repo not initialized, creating..." -ForegroundColor Yellow
        git init
        git config user.email "your@email.com"
        git config user.name "Your Name"
        Write-Host "   Please add remote manually: git remote add origin https://github.com/YOUR_USERNAME/your-repo.git" -ForegroundColor Cyan
    }
}

Write-Host ""
$syncScript = Join-Path $scriptDir "sync.ps1"
Write-Host "Run sync: powershell -ExecutionPolicy Bypass -File `"$syncScript`"" -ForegroundColor Cyan

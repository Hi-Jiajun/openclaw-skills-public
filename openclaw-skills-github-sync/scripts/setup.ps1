# OpenClaw Skills GitHub Sync - Interactive Setup

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "OpenClaw Skills GitHub Sync - 交互式配置向导" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 GitHub CLI
$ghPath = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghPath) {
    Write-Host "GitHub CLI 未安装" -ForegroundColor Red
    Write-Host "请先安装: winget install GitHub.cli" -ForegroundColor Yellow
    exit 1
}

Write-Host "1. GitHub 登录状态检查..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($authStatus -match "Logged in") {
    Write-Host "   已登录 GitHub" -ForegroundColor Green
} else {
    Write-Host "   请先登录 GitHub" -ForegroundColor Yellow
    Write-Host "   运行: gh auth login" -ForegroundColor Cyan
    exit 1
}

Write-Host ""
Write-Host "2. 设置私有 Skills 本地路径" -ForegroundColor Yellow
Write-Host "   示例: C:\Users\YourName\openclaw-skills-private"
$privatePath = Read-Host "   输入路径"

Write-Host ""
Write-Host "3. 设置公开 Skills 本地路径" -ForegroundColor Yellow
Write-Host "   示例: C:\Users\YourName\openclaw-skills-public"
$publicPath = Read-Host "   输入路径"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "私有 Skills: $privatePath" -ForegroundColor White
Write-Host "公开 Skills: $publicPath" -ForegroundColor White
Write-Host ""

# 保存配置
$config = @"
`$privatePath = "$privatePath"
`$publicPath = "$publicPath"
"@

$configFile = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "config.ps1"
$config | Out-File -FilePath $configFile -Encoding UTF8

Write-Host "配置已保存到: $configFile" -ForegroundColor Green

# 检查并初始化 Git 仓库
Write-Host ""
Write-Host "检查 Git 仓库..." -ForegroundColor Yellow

if (Test-Path $privatePath) {
    Set-Location $privatePath
    if (-not (Test-Path ".git")) {
        Write-Host "   私有仓库未初始化，正在创建..." -ForegroundColor Yellow
        git init
        git config user.email "your@email.com"
        git config user.name "Your Name"
        Write-Host "   请手动添加 remote: git remote add origin https://github.com/YOUR_USERNAME/your-repo.git" -ForegroundColor Cyan
    }
}

if (Test-Path $publicPath) {
    Set-Location $publicPath
    if (-not (Test-Path ".git")) {
        Write-Host "   公开仓库未初始化，正在创建..." -ForegroundColor Yellow
        git init
        git config user.email "your@email.com"
        git config user.name "Your Name"
        Write-Host "   请手动添加 remote: git remote add origin https://github.com/YOUR_USERNAME/your-repo.git" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "运行同步: powershell -ExecutionPolicy Bypass -File `"$configFile\..\sync.ps1`"" -ForegroundColor Cyan

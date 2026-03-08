# OpenClaw Skills GitHub Sync Script
# ==== 请根据你的路径修改以下配置 ====
$privatePath = "C:\Users\hiliang\Documents\openclaw-skills-private"   # 私有 skills 路径
$publicPath = "C:\Users\hiliang\Documents\openclaw-skills-public"     # 公开 skills 路径

Write-Host "=========================================="
Write-Host "OpenClaw Skills GitHub Sync"
Write-Host "=========================================="

$gitPath = "C:\Program Files\Git\cmd\git.exe"

# Function to sync a repository
function Sync-Repo {
    param($repoPath, $repoName)
    
    if (-not (Test-Path $repoPath)) {
        Write-Host "[SKIP] $repoName not found"
        return
    }
    
    Set-Location $repoPath
    $status = & $gitPath status --porcelain
    
    if ($status) {
        Write-Host "Changes in $repoName"
        $status | ForEach-Object { Write-Host "  $_" }
        
        & $gitPath add .
        & $gitPath commit -m "Sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        & $gitPath push origin main
        
        Write-Host "[OK] $repoName synced"
    } else {
        Write-Host "[OK] $repoName - No changes"
    }
}

# Sync private skills
Write-Host ""
Write-Host "--- Private Skills ---"
Sync-Repo -repoPath $privatePath -repoName "Private"

# Sync public skills  
Write-Host ""
Write-Host "--- Public Skills ---"
Sync-Repo -repoPath $publicPath -repoName "Public"

Write-Host ""
Write-Host "=========================================="

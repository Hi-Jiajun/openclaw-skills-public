# OpenClaw Backup Script
# ==== 配置加载 ====
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = Join-Path $scriptDir "config.ps1"

if (Test-Path $configFile) {
    . $configFile
} else {
    # 默认配置
    $backupRoot = "Z:\backup\openclaw_backup"
    $oldBackupRoot = "Z:\backup\openclaw_backup_old"
    $openclawHome = "$env:USERPROFILE\.openclaw"
    $keepCount = 3
    $maxOldSizeGB = 10
    $targetOldSizeGB = 5
}

# ============================================
$backupDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

Write-Host "=========================================="
Write-Host "OpenClaw Backup Start - $backupDate"
Write-Host "=========================================="

# Create backup directory
$backupDir = "$backupRoot\$backupDate"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

# Backup items
$backupItems = @(
    @{src="$openclawHome\openclaw.json"; name="openclaw.json"},
    @{src="$openclawHome\agents"; name="agents"; isDir=$true},
    @{src="$openclawHome\credentials"; name="credentials"; isDir=$true},
    @{src="$openclawHome\cron"; name="cron"; isDir=$true},
    @{src="$openclawHome\devices"; name="devices"; isDir=$true},
    @{src="$openclawHome\identity"; name="identity"; isDir=$true},
    @{src="$openclawHome\skills"; name="skills"; isDir=$true}
)

$successCount = 0
$failCount = 0

foreach ($item in $backupItems) {
    $src = $item.src
    $name = $item.name
    
    if (Test-Path $src) {
        $dest = "$backupDir\$name"
        try {
            if ($item.isDir) {
                Copy-Item -Path $src -Destination $dest -Recurse -Force -ErrorAction Stop
            } else {
                Copy-Item -Path $src -Destination $dest -Force -ErrorAction Stop
            }
            Write-Host "[OK] $name"
            $successCount++
        } catch {
            Write-Host "[FAIL] $name - $_"
            $failCount++
        }
    } else {
        Write-Host "[SKIP] $name (not found)"
    }
}

# Create restore guide
$restoreGuide = @"
# OpenClaw Backup Restore Guide
# Backup Time: $backupDate

## Restore Methods

### Method 1: Full Restore
1. Stop OpenClaw Gateway
2. Backup current config
3. Copy files from backup to $openclawHome
4. Restart Gateway

### Method 2: Selective Restore
- Restore config: copy "$backupDir\openclaw.json" "$openclawHome\"
- Restore skills: xcopy /E /I "$backupDir\skills" "$openclawHome\skills\"

## Notes
- Restore path: $backupDir
"@

$restoreGuide | Out-File -FilePath "$backupDir\RESTORE.md" -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host "Backup Complete!"
Write-Host "Backup Location: $backupDir"
Write-Host "Success: $successCount, Failed: $failCount"
Write-Host "=========================================="

# Cleanup old backups
if ($keepCount -gt 0) {
    $allBackups = Get-ChildItem -Path $backupRoot -Directory -ErrorAction SilentlyContinue | Where-Object { 
        $_.Name -ne "my-own-skills" 
    } | Sort-Object LastWriteTime -Descending

    if ($allBackups -and $allBackups.Count -gt $keepCount) {
        Write-Host ""
        Write-Host "Cleaning old backups (keep latest $keepCount)..."
        $allBackups | Select-Object -Skip $keepCount | ForEach-Object {
            $oldDir = "$oldBackupRoot\$($_.Name)"
            New-Item -ItemType Directory -Force -Path $oldDir | Out-Null
            Move-Item $_.FullName $oldDir -Force
            Write-Host "[MOVED] $($_.Name) -> old backup"
        }
    }
}

# Old backup size cleanup
if ($oldBackupRoot -and (Test-Path $oldBackupRoot)) {
    Write-Host ""
    Write-Host "Checking old backups size..."
    
    $oldFolders = Get-ChildItem -Path $oldBackupRoot -Directory -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
    $totalSizeGB = 0
    
    foreach ($folder in $oldFolders) {
        $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB
        if ($size) { $totalSizeGB += $size }
    }
    
    Write-Host "Old backups total size: $([math]::Round($totalSizeGB, 2)) GB"
    
    if ($totalSizeGB -gt $maxOldSizeGB) {
        Write-Host "Cleaning to $targetOldSizeGB GB..."
        
        $oldFolders = Get-ChildItem -Path $oldBackupRoot -Directory -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
        
        foreach ($folder in $oldFolders) {
            if ($totalSizeGB -le $targetOldSizeGB) { break }
            $size = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB
            if ($size) {
                Remove-Item $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
                $totalSizeGB -= $size
                Write-Host "[DELETED] $($folder.Name)"
            }
        }
    }
}

Write-Host ""
Write-Host "=========================================="
